class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :created_at, :user
  include CommentableSerializer
  include AttachableSerializer
end
