module Associations
  extend ActiveSupport::Concern
  included  do
    has_many :attachments, as: :attachable, dependent: :destroy
    has_many :rates, as: :ratable, dependent: :destroy
    accepts_nested_attributes_for :attachments, reject_if: :all_blank

    def rating
      rates.sum(:value)
    end
  end
end
