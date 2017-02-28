require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'validations' do
    it { should belong_to(:question) }
    it { should validate_presence_of :body }
  end
end

