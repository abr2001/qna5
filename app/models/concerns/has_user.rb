module HasUser
  extend ActiveSupport::Concern
  included  do
    belongs_to :user
    validates  :user, presence: true
  end
end
