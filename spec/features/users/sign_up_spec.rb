require 'rails_helper'

feature 'Siging up', %q{
  In order to be able ask questions
  As an user
  I want be able to sign up
 } do

  scenario "New user try to sign up" do
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario "New user try to sign up with invalid data" do
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: 'bla bla'
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content 'Email is invalid'
    expect(page).to have_content "Password can't be blank"
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

end
