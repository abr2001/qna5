class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at, :user
  has_many :comments
  include CommentableSerializer
  include AttachableSerializer
end
