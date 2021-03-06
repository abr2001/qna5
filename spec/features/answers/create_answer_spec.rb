require 'features/features_helper'

feature 'Create answer', %q{
  In order to get answer from community
  I want to be able to ask the question
} do

  let(:question) { create(:question) }
  let!(:user) { create(:user) }

  scenario 'User create the answer', js: true do
    login_user
    visit question_path(question.id)
    within('.new_answer') do
      fill_in 'Answer', with: 'text text text'
      click_on 'Create'
    end
    expect(current_path).to eq question_path(question)
    within('.answers') do
      expect(page).to have_content 'text text text'
    end
  end

  scenario 'user enters invalid data', js: true do
    login_user
    visit question_path(question.id)
    within('.new_answer') do
      fill_in 'Answer', with: ''
      click_on 'Create'
    end
    expect(current_path).to eq question_path(question)
    within('.answers') do
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'a non-authenticated user tries to answer' do
    visit question_path(question.id)
    expect(page).to_not have_link 'Create'
  end

  context "multiple sessions", :cable do
    scenario "all users see new answer in real-time", js: true do
      Capybara.using_session("user") do
        login_user
        visit question_path(question)
      end

      Capybara.using_session("guest") do
        visit question_path(question)
      end

      Capybara.using_session("user") do
        within('.new_answer') do
          fill_in 'Answer', with: 'text text text'
          click_on 'Create answer'
        end
        within('.answers') do
          expect(page).to have_content 'text text text'
        end
      end

      Capybara.using_session("guest") do
        within('.answers') do
          expect(page).to have_content 'text text text'
        end
      end
    end
  end

end
