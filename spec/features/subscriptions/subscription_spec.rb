require 'features/features_helper'

feature 'Subscribe question', %q{
User can subscribe question
he liked
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: other_user) }

  scenario 'Authenticated user can subscribe and unsubscribe', js: true do
    login_user
    visit question_path(question.id)
    within  "#subscription" do
      expect(page).to have_link('Subscribe')
      click_link 'Subscribe'
      expect(page).to have_link('Unsubscribe')
      click_link 'Unsubscribe'
      expect(page).to have_link('Subscribe')
    end
  end

  scenario 'Not authenticated user cant subscribe', js: true do
    visit questions_path

    expect(page).to_not have_link('Subscribe')
  end
end
