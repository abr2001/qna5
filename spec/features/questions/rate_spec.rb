require 'features/features_helper'

feature 'add rate to question', %q{
  In order to evaluate the question
  Authenticated user
  I want to rate the question
} do

  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'The autor of question can not rate', js: true do
    login_user
    visit question_path(question.id)
    within('.action-question') do
      expect(page).to_not have_link '+'
    end
  end

  scenario 'The user puts a plus for the question', js: true do
    login_another_user
    visit question_path(question.id)
    within('.action-question') do
      click_on '+'
    end
    within('.rating-question') do
      expect(page).to have_content '1'
    end
  end


end
