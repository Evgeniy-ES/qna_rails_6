class AnswerFullSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :text, :created_at, :updated_at
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many :comments
  has_many :links
  has_many :files

end
