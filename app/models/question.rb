class Question < ApplicationRecord
  include HasAttachments
  include HasRates
  include HasUser
  include HasComments

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  after_create :subscribe_author

  def subscribe_author
    Subscription.create!(user: user, question: self)
  end

  def subscribed_by?(user)
    subscriptions.where(user: user).exists?
  end

  def find_subscription(user)
    subscriptions.where(user: user).first
  end

  scope :list, -> { includes(:user).all.order(id: :desc) }
end
