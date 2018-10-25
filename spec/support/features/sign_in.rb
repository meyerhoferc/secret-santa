module Features
  def sign_in
#    before { @user = User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'passpass') }
    @user = User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'passpass')

    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'pass'
    click_on 'Log In'
  end
end
