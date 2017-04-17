require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:rates) }

  let!(:user) { create :user }
  let!(:question) { create :question, user: user }

  it 'the user is the author of the question' do
    expect(user).to be_author_of(question)
  end

  let!(:user_not_author) { create :user }
  it 'the user is not the author of the question' do
    expect(user_not_author).to_not be_author_of(question)
  end

  let!(:question_2) { create :question, user: user }
  describe 'User rate ' do
    it 'for question' do
      rate = question.rates.create(user_id: user.id, value: 1)
      expect(user.rate_of(question)).to eq(1)
    end
    it 'for question_2' do
      rate = question_2.rates.create(user_id: user.id, value: -1)
      expect(user.rate_of(question_2)).to eq(-1)
    end
  end

  describe 'User has rate?' do
    it 'for question' do
      rate = question.rates.create(user_id: user.id, value: 1)
      expect(user).to be_has_rate(question)
    end
    it 'for question_2' do
      expect(user).to_not be_has_rate(question_2)
    end
  end


end
