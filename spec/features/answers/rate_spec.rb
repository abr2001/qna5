require 'features/features_helper'

feature 'add rate to answer', %q{
  In order to evaluate the answer
  Authenticated user
  I want to rate the answer
} do

  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, user: user, question: question) }

  scenario 'The auhtor of answer can not rate', js: true do
    login_user
    visit question_path(question.id)
    within('.answer') do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end

  scenario 'The user rate for the answer', js: true do
    login_another_user
    visit question_path(question.id)
    within('.answer') do
      click_on '+'
    end
    within('.rating-answer') do
      expect(page).to have_content '1'
    end
    within('.answer') do
      click_on '+'
    end
    within('.rating-answer') do
      expect(page).to have_content '1'
    end
    within('.rate-answer-errors') do
      expect(page).to have_content 'You already has rate'
    end
    within('.answer') do
      click_on 'Cancel rate'
    end
    within('.rating-answer') do
      expect(page).to have_content '0'
    end
    within('.answer') do
      click_on '-'
    end
    within('.rating-answer') do
      expect(page).to have_content '-1'
    end
  end


end
