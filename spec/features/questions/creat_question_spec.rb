require 'features/features_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
} do

  let!(:user) { create(:user) }

  scenario 'User create the question' do
    login_user
    visit questions_path
    click_on 'New question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
    click_on 'Save'
    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'user enters invalid data' do
    login_user
    visit questions_path
    click_on 'New question'
    fill_in 'Title', with: ''
    fill_in 'Text', with: ''
    click_on 'Save'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'a non-authenticated user tries create question' do
    visit questions_path
    click_on 'New question'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  context "multiple sessions", :cable do
    scenario "all users see new question in real-time", js: true do
      Capybara.using_session('user') do
        login_user
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'New question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Text', with: 'text text text'
        click_on 'Save'
        expect(page).to have_content 'Question was successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

end
