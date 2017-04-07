class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :ratable, polymorphic: true, optional: true

  validates :user, :value, presence: true
  validate :check_user_already_has_rate

  private

  def check_user_already_has_rate
    if Rate.where(user_id: user_id).
      where(ratable_id: ratable_id).
      where(ratable_type: ratable_type).exists?
      errors.add(:base, 'User already has rate')
    end
  end

end
