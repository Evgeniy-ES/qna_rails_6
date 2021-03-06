class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true

  after_create :calculate_reputation

  def set_best_answer(answer)
    transaction do
      self.update!(best_answer: answer)
      self.reward&.update!(user: answer.author)
    end
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

end
