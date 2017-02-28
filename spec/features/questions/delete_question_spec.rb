require 'rails_helper'

feature 'delete question', %q{
  In order to delete question
  Authenticated user
  I want delete  question
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'User delete the own question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    visit question_path(question.id)
    click_on 'Delete question'
    expect(page).to have_content 'Your question successfully deleted'
  end
end
