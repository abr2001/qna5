require 'features/features_helper'

feature 'delete answer for question', %q{
  In order to delete answers for question
  Authenticated user
  I want delete  answer for question
} do

  let!(:question) { create(:question) }
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer, user: user, body: 'my answer for question', question: question) }

  scenario 'The user deletes their answer', js: true do
    login_user
    visit question_path(question.id)
    click_on 'Delete'
    expect(page).to_not have_content 'my answer for question'
  end

  scenario 'a non-authenticated user tries delete own answer' do
    visit question_path(question.id)
    expect(page).to_not have_content 'Delete'
  end

  let!(:another_user) { create(:user) }
  scenario "The user tries to delete someone else's answer" do
    login_another_user
    visit question_path(question.id)
    expect(page).to_not have_content 'Delete'
  end

end
