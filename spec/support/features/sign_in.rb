module Features
  def sign_in
    @user = User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'passp1203489y132809hass')
    sign_in_as(@user)
  end

  def sign_in_as(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'
  end

  def fill_out_user_signup_no_email(user)
    fill_in('user[first_name]', with: user.first_name)
    fill_in('user[last_name]', with: user.last_name)
    fill_in('user[password]', with: user.password)
    fill_in('user[password_confirmation]', with: user.password)
  end

  def dashboard_path_content(user)
    expect(page).to have_content "Welcome, #{user.first_name}."
    expect(page).to have_link 'Sign Out'
    expect(page).to have_link 'Profile'
    expect(page).not_to have_link 'Log In'
    expect(page).not_to have_link 'Sign Up'
  end
end
