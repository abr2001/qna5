require 'rails_helper'

RSpec.describe Rate, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:ratable) }

  it { should validate_presence_of :user }
  it { should validate_presence_of :value }


  let!(:user) { create :user }
  let!(:question) { create :question }
  describe 'User can not re-rate' do
    before { rate = question.rates.create(user_id: user.id) }
    it 'get valid errors' do
      expect(rate.errors.messages.to_s).to include("User already_has_rate")
    end
  end

end
