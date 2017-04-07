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

end
