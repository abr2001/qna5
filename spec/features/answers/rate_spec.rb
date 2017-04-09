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
  let!(:answer_2) { create(:answer, user: user, question: question) }

  scenario 'The auhtor of answer can not rate', js: true do
    login_user
    visit question_path(question.id)
    within("#answer-#{answer.id}") do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
    within("#answer-#{answer_2.id}") do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end

  context 'not auhtor of answer' do

    before {
      login_another_user
      visit question_path(question.id)
      }

    scenario 'The user rate for the answer', js: true do
      within("#answer-#{answer.id}") do
        click_on '+'
        within('.rating') do
          expect(page).to have_content '1'
        end
        expect(page).to have_link 'Cancel rate'
      end
      within("#answer-#{answer_2.id}") do
        within('.rating') do
          expect(page).to have_content '0'
        end
        expect(page).to_not have_link 'Cancel rate'
      end
    end


    scenario 'The user can not re-rate for the answer', js: true do
      within("#answer-#{answer.id}") do
        click_on '+'
        within('.rating') do
          expect(page).to have_content '1'
        end
        click_on '+'
        within('.rate-errors') do
          expect(page).to have_content 'You already has rate'
        end
      end
      within("#answer-#{answer_2.id}") do
        within('.rate-errors') do
          expect(page).to_not have_content 'You already has rate'
        end
      end
    end

    scenario 'The user negative rate for the answer', js: true do
       within("#answer-#{answer.id}") do
        click_on '-'
        within('.rating') do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'The user can cancel rate for the answer', js: true do
       within("#answer-#{answer.id}") do
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
