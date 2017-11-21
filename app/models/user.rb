class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def rate_of(item)
    rate = item.rates.where(user_id: id).first
    rate.nil? ? 0 : rate.value
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    if auth.info.try(:[], :email)
      email = auth.info[:email]
      user = User.where(email: email).first
      if user
        User.transaction do
          user.update(confirmed_at: nil)
          user.send_confirmation_instructions
          user.create_authorization(auth)
        end
      else
        password = Devise.friendly_token[0, 20]
        User.transaction do
          user = User.create!(email: email, password: password, password_confirmation: password)
          user.create_authorization(auth)
        end
      end
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end
end
