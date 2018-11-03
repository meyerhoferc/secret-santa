require 'rails_helper'

describe 'user signup' do
  context 'with a new user' do
    it 'they can create an account' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_in('user[first_name]', with: 'Ra')
      fill_in('user[last_name]', with: 'Zz')
      fill_in('user[email]', with: 'email@email.email')
      fill_in('user[password]', with: 'passpass')
      fill_in('user[password_confirmation]', with: 'passpass')
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: 'email@email.email')
      fill_in('password', with: 'passpass')
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      expect(page).to have_content 'Welcome, Ra.'
      expect(page).to have_link 'Sign Out'
      expect(page).to have_link 'Profile'
      expect(page).not_to have_link 'Log In'
      expect(page).not_to have_link 'Sign Up'
    end
  end

  context 'as an existing, logged in user' do
    it 'redirects from /signup to dashboard' do
      u = User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'passpass')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(u)
      visit signup_path
      expect(current_path).to eq dashboard_path
    end
  end
end
