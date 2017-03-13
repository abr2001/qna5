require 'features/features_helper'

feature 'best answer for question', %q{
  In order to best answer for question
  Authenticated user
  I want do best answer for question
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, :with_user, question: question) }
  let!(:answer_2) { create(:answer, :with_user, question: question) }
  let!(:answer_3) { create(:answer, :with_user, question: question) }

  scenario 'The login user as author of question sees a button "Best answer"' do
    login_user
    visit question_path(question.id)
    within('.answers') do
      expect(page).to have_link 'Best answer'
    end
  end

  scenario 'The not login user not sees a button "Best answer"' do
    visit question_path(question.id)
    within('.answers') do
      expect(page).to_not have_link 'Best answer'
    end
  end

  let!(:question2) { create(:question) }
  let!(:answer_22) { create(:answer, :with_user, question: question2) }
  scenario 'The login user as not author of question not sees a button "Best answer"' do
    login_user
    visit question_path(question2.id)
    within('.answers') do
      expect(page).to_not have_link 'Best answer'
    end
  end

  after {answer_2.reload}
  scenario 'The user wants to select the best answer', js: true do
    login_user
    visit question_path(question.id)
    within("#answer-#{answer_2.id}") do
      click_on 'Best answer'
      expect(answer_2.best).to eq true
    end
  end

end
