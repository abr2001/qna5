require 'rails_helper'

feature 'Siging out' do
  let!(:user) { create(:user) }
  scenario "Authenticated user try to sign out" do
    login_user
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
