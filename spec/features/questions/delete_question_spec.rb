require 'rails_helper'

feature 'delete question', %q{
  In order to delete question
  Authenticated user
  I want delete  question
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'User delete the own question' do
    login_user
    visit question_path(question.id)
    click_on 'Delete question'
    expect(page).to have_content 'Your question successfully deleted'
  end

  scenario 'a non-authenticated user tries delete own question' do
    visit question_path(question.id)
    expect(page).to_not have_content 'Delete question'
  end

  let!(:another_user) { create(:user) }
  scenario "The user tries to delete someone else's question" do
    login_another_user
    visit question_path(question.id)
    expect(page).to_not have_content 'Delete question'
  end

end
