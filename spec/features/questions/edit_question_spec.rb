require 'features/features_helper'

feature 'edit question', %q{
  In order to edit question
  Authenticated user
  I want change question
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'The user edit their question', js: true do
    login_user
    visit question_path(question.id)
    within('.question') do
      click_on 'Edit'
      fill_in 'Title', with: 'my new Title'
      fill_in 'Text', with: 'my new question'
      click_on 'Save'
      expect(page).to_not have_selector 'textarea'
      expect(page).to have_content 'my new question'
      expect(page).to have_content 'my new Title'
      expect(page).to_not have_content question.body
      expect(page).to_not have_content question.title
    end
  end

  scenario 'a non-authenticated user edit own question' do
  end

  let!(:another_user) { create(:user) }
  scenario "The user tries to edit someone else's question" do
  end

end
