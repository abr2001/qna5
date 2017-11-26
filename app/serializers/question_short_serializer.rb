class QuestionShortSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :created_at
end
