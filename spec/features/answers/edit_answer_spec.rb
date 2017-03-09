require 'features/features_helper'

feature 'edit answer for question', %q{
  In order to edit answers for question
  Authenticated user
  I want change answer for question
} do

  let!(:question) { create(:question) }
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer, user: user, body: 'my answer for question', question: question) }

  scenario 'The user edit their answer', js: true do
    login_user
    visit question_path(question.id)
    within('.answer') do
      click_on 'Edit'
      fill_in 'Answer', with: 'my new answer'
      click_on 'Update'
    end
    expect(page).to have_content 'my new answer'
    expect(page).to_not have_content answer.body
    expect(page).to_not have_selector 'textarea'
  end

  scenario 'a non-authenticated user edit own answer' do
  end

  let!(:another_user) { create(:user) }
  scenario "The user tries to edit someone else's answer" do
  end

end
