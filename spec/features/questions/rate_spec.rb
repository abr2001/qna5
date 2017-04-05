require 'features/features_helper'

feature 'add rate to question', %q{
  In order to evaluate the question
  Authenticated user
  I want to rate the question
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  scenario 'The user puts a plus for the question', js: true do
    login_user
    visit question_path(question.id)
    within('.action-question') do
      click_on '+'
    end
    save_and_open_page
    within('.rating-question') do
      expect(page).to have_content '1'
    end
  end
end
