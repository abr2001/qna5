class Question < ApplicationRecord
  include Associations
  include HasUser

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
