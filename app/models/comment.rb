class Comment < ApplicationRecord
  include HasUser
  belongs_to :commentable, polymorphic: true, optional: true

  validates :body, presence: true
end
