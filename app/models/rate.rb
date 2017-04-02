class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :ratable, polymorphic: true, optional: true

  validates :user, presence: true
end
