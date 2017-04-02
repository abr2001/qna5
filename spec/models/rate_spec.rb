require 'rails_helper'

RSpec.describe Rate, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:ratable) }

  it { should validate_presence_of :user }
end
