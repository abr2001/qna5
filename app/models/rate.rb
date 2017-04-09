class Rate < ApplicationRecord
  include HasUser
  belongs_to :ratable, polymorphic: true, optional: true

  validates :value, presence: true
  validate :check_user_already_has_rate

  private

  def check_user_already_has_rate
    errors.add(:base, 'You already has rate') if Rate.where(user_id: user_id, ratable: ratable).exists?
  end

end
