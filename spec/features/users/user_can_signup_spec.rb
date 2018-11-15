require 'rails_helper'

describe 'user signup' do
  context 'a new user' do
    before { @user = {first_name: 'Joey', last_name: 'Ralf', email: 'emati@l.com', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs' }}
    it 'can create an account' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_in('user[first_name]', with: @user[:first_name])
      fill_in('user[last_name]', with: @user[:last_name])
      fill_in('user[email]', with: @user[:email]);
      fill_in('user[password]', with: @user[:password])
      fill_in('user[password_confirmation]', with: @user[:password])
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('Email', with: @user[:email])
      fill_in('Password', with: @user[:password])
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      expect(page).to have_content "Welcome, #{@user[:first_name]}."
      expect(page).to have_link 'Sign Out'
      expect(page).to have_link 'Profile'
      expect(page).not_to have_link 'Log In'
      expect(page).not_to have_link 'Sign Up'
    end
  end
  context 'incorrectly with' do
    it 'blank credentials' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path

      click_on 'Create User'

      expect(page).to have_content 'Please enter valid credentials.'
      expect(current_path).to eq signup_path
    end

    it 'invalid email format'
  end

  context 'with an email' do
    let(:user) { User.create(first_name: 'Joey', last_name: 'Ralf', email: 'eMaIl@EmAiL.emaILE', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs') }
    it 'signup uppercase, login mixed-case' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in 'user[email]', with: user.email.upcase
      click_on 'Create User'

      expect(current_path).to eq login_path
      sign_in_as(user)

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup uppercase, login uppercase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in 'user[email]', with: user.email.upcase
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in 'email', with: user.email.upcase
      fill_in 'password', with: user.password
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup uppercase, login downcase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user.email.upcase)
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user.email.downcase)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup mixed-case, login mixed-case' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user.email)
      click_on 'Create User'

      expect(current_path).to eq login_path
      sign_in_as(user)

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup mixed-case, login uppercase' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user.email)
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user.email.upcase)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup mixed-case, login downcase' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user.email)
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user.email.downcase)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup downcase, login mixed-case' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user.email.downcase)
      click_on 'Create User'

      expect(current_path).to eq login_path
      sign_in_as(user)

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup downcase, login uppercase' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user.email.downcase)
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user.email.upcase)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup downcase, login downcase' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user.email.downcase)
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user.email.downcase)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end
  end

  context 'as an existing, logged in user' do
    it 'redirects from /signup to dashboard' do
      u = User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'pa1203489y132809hssp1203489y132809hass')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(u)
      visit signup_path
      expect(current_path).to eq dashboard_path
    end
  end
end
