require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:answer) { create :answer, question: question, user: user}

  describe 'the user is the author' do
    it 'of the question' do
      expect(user.author_of?(question)).to eq(true)
    end

    it 'of the answer' do
      expect(user.author_of?(answer)).to eq(true)
    end
  end

  let!(:user_not_author) { create :user }
  describe 'the user is not the author' do
    it 'of the question' do
      expect(user_not_author.author_of?(question)).to eq(false)
    end

    it 'of the answer' do
      expect(user_not_author.author_of?(answer)).to eq(false)
    end
  end

end
