require 'features/features_helper'

feature 'add rate to question', %q{
  In order to evaluate the question
  Authenticated user
  I want to rate the question
} do

  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'The auhtor of question can not rate', js: true do
    login_user
    visit question_path(question.id)
    within('.action-question') do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end

  context 'not auhtor of question' do

    before {
      login_another_user
      visit question_path(question.id)
      }

    scenario 'The user rate for the question', js: true do
      within('.action-question') do
        click_on '+'
        within('.rating') do
          expect(page).to have_content '1'
        end
        expect(page).to have_link 'Cancel rate'
      end
    end


    scenario 'The user can not re-rate for the question', js: true do
      within('.rate-question') do
        click_on '+'
        within('.rating') do
          expect(page).to have_content '1'
        end
        click_on '+'
        within('.rate-errors') do
          expect(page).to have_content 'You already has rate'
        end
      end
    end

    scenario 'The user negative rate for the question', js: true do
      within('.rate-question') do
        click_on '-'
        within('.rating') do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'The user can cancel rate for the question', js: true do
      within('.rate-question') do
        click_on '-'
        within('.rating') do
          expect(page).to have_content '-1'
        end
        click_on 'Cancel rate'
        within('.rating') do
          expect(page).to have_content '0'
        end
      end
    end
  end
end
