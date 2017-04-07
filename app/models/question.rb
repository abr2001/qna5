class Question < ApplicationRecord
  include Associations
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user, presence: true

end
