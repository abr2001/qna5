class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :rates, as: :ratable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def  rating
    rates.sum(:value)
  end

end
