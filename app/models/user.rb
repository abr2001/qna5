class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :vkontakte]
  has_many :answers
  has_many :questions
  has_many :rates

  def author_of?(item)
    id == item.user_id
  end

  def has_rate?(item)
    item.rates.where(user_id: id).exists?
  end

  def rate_of(item)
    rate = item.rates.where(user_id: id).first
    rate.nil? ? 0 : rate.value
  end

end
