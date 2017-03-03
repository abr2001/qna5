require 'rails_helper'

feature 'delete answer for question', %q{
  In order to delete answers for question
  Authenticated user
  I want delete  answer for question
} do

  let!(:question) { create(:question) }
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer, user: user, body: 'my answer for question', question: question) }

  scenario 'User delete the own answers' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    visit question_path(question.id)
    click_on 'Delete'
    expect(page).to have_content 'Your answer successfully deleted'
  end
end
