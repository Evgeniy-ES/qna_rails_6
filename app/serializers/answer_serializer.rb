class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :text, :user_id, :created_at, :updated_at, :question_id

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
end
