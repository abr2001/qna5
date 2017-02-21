require 'rails_helper'

feature 'Siging in', %q{
  In order to be able ask questions
  As an user
  I want be able to sign in
 } do

  let(:user) { create(:user) }

  scenario "Existing user try to sign in" do
    visit new_user_session_path
    save_and_open_page
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario "Authenticated user try to sign out" do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Non-existing user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@user.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end

end
