class Answer < ApplicationRecord
  include Votable
  include Commentable


  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :text, presence: true

end
