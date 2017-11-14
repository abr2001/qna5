require 'features/features_helper'

feature 'Create comment in show question', %q{
I want to be able
to  leave my comment at question page
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  scenario 'Authenticated user try to leave comment to the question', js: true do
    login_user
    visit question_path question

    within '.question' do
      click_on 'Add comment'
      find('#comment_body').set('My comment')
      click_on 'Send comment'
    end
    expect(page).to have_content 'My comment'
  end

  scenario 'Authenticated user try to leave comment to the answer', js: true do
    login_user
    visit question_path question

    within '.answer' do
      click_on 'Add comment'
      find('#comment_body').set('My comment')
      click_on 'Send comment'
    end
    expect(page).to have_content 'My comment'
  end

  scenario 'Nonauthenticated user cant leave comment', js: true do
    visit question_path question
    expect(page).to have_no_content 'New comment'
  end

  context "multiple sessions", :cable do
    scenario "comment appears on other users page", js: true do
      Capybara.using_session('user') do
        login_user
        visit question_path question
      end
      Capybara.using_session('guest') do
        visit question_path question
      end
      Capybara.using_session('user') do
        within '.question' do
          click_on 'Add comment'
          find('#comment_body').set('My comment')
          click_on 'Send comment'
        end
        within '.list-comment-question' do
          expect(page).to have_content 'My comment'
        end
      end
      Capybara.using_session('guest') do
        within '.list-comment-question' do
          expect(page).to have_content 'My comment'
        end
      end
    end
  end
end
