require 'rails_helper'

feature 'Create answer', %q{
  In order to get answer from community
  I want to be able to ask the question
} do

  let(:question) { create(:question) }
  let!(:user) { create(:user) }

  scenario 'User create the answer' do
    login_user
    visit question_path(question.id)

    fill_in 'Answer', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'text text text'
  end

  scenario 'user enters invalid data' do
    login_user
    visit question_path(question.id)

    fill_in 'Answer', with: ''
    click_on 'Create'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'a non-authenticated user tries to answer' do
    visit question_path(question.id)

    fill_in 'Answer', with: 'test text'
    click_on 'Create'
    expect(page).to have_content "You need to sign in or sign up before continuing"
  end

end
