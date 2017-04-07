class Question < ApplicationRecord
  include HasAttachments
  include HasRates
  include HasUser

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
