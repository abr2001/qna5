module FeatureMacros
  def login_user
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def login_another_user
    visit new_user_session_path
    fill_in 'Email', with: another_user.email
    fill_in 'Password', with: another_user.password
    click_on 'Log in'
  end

end
