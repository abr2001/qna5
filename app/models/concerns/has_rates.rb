module HasRates
  extend ActiveSupport::Concern
  included  do
    has_many :rates, as: :ratable, dependent: :destroy

    def rating
      rates.sum(:value)
    end
  end
end
