require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user }
  end
end

