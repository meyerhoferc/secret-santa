module Features
  def sign_in(user)
    visit login_path
    fill_in 'Username or email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'
  end

  def sign_in_username(user)
    visit login_path
    fill_in 'Username or email', with: user.username
    fill_in 'Password', with: user.password
    click_on 'Log In'
  end

  def sign_in_as(user)
    visit login_path
    fill_in 'Username or email', with: user[:email]
    fill_in 'Password', with: user[:password]
    click_on 'Log In'
  end

  def fill_out_user_signup_no_email(user)
    fill_in('user[first_name]', with: user[:first_name])
    fill_in('user[last_name]', with: user[:last_name])
    fill_in('user[username]', with: user[:username])
    fill_in('user[password]', with: user[:password])
    fill_in('user[password_confirmation]', with: user[:password])
  end

  def dashboard_path_content(user)
    expect(page).to have_content "Welcome #{user[:first_name]}"
    expect(page).to have_link 'Log Out'
    expect(page).to have_link 'Profile'
    expect(page).not_to have_link 'Log In'
    expect(page).not_to have_link 'Sign Up'
  end

  def sign_out
    click_on 'Log Out'
  end
end
