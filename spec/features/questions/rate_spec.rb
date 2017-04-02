require 'features/features_helper'

feature 'edit question', %q{
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
    within('.rating-questionn') do
      expect(page).to have_content '1'
    end
  end
end
