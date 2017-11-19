require 'features/features_helper'

feature 'Authenticate with OmniAuth', %q{
  I want to be able
  to login using social networks
} do
  describe "User try to login using Facebook" do
    let(:user) { create(:user) }
    scenario "New user first time try to login using facebook", js: true do
      visit new_user_session_path
      expect(page).to have_content('Sign in with Facebook')
      mock_auth_hash(:facebook)
      click_on 'Sign in with Facebook'
      expect(page).to have_content('You have to confirm your email address before continuing.')
    end

    scenario "Existing user first time try to login using Facebook", js: true do
      auth = mock_auth_hash(:facebook)
      user.update!(email: auth.info.email)
      visit new_user_session_path
      expect(page).to have_content('Sign in with Facebook')
      click_on 'Sign in with Facebook'
      open_email(auth.info.email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed')
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Successfully authenticated from facebook account')
    end

    scenario "Existing authorized Facebook user try again to login using Facebook", js: true do
      auth = mock_auth_hash(:facebook)
      user.update!(email: auth.info.email)
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      visit new_user_session_path
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Successfully authenticated from facebook account')
    end
  end

  describe "New user try to login using Twitter" do
    let(:email) { 'twitter@mail.ru' }
    let(:user)  { create(:user, email: email) }
    let!(:auth)  { mock_auth_hash(:twitter) }
    scenario "User first time try to login using Twitter", js: true do
      visit new_user_session_path
      expect(page).to have_content('Sign in with Twitter')
      click_on 'Sign in with Twitter'
      expect(page).to have_content('Email')
      fill_in 'auth_info_email', with: email
      click_on 'Отправить'
      expect(page).to have_content('You have to confirm your email address before continuing')
    end

    scenario "Existing user first time try to login using Twitter", js: true do
      visit new_user_session_path
      expect(page).to have_content('Sign in with Twitter')
      click_on 'Sign in with Twitter'
      expect(page).to have_content('Email')
      fill_in 'auth_info_email', with: email
      click_on 'Отправить'
      expect(page).to have_content('You have to confirm your email address before continuing')
      open_email(email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed')
      click_on 'Sign in with Twitter'
      expect(page).to have_content('Successfully authenticated from twitter account')
    end

    scenario "Existing authorized Twitter user try again to login using Twitter", js: true do
      authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content('Successfully authenticated from twitter account')
    end
  end
end
