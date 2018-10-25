require 'rails_helper'

describe "user login" do
  # Examples
  # before { @user = User.create() }
  # let(:user) { User.create() }
  # let!(:user) { User.create() }
  # before { @user = User.create(first_name: 'Test', last_name: 'Ing', email: 'test@ing.com', password: 'password') }
  let(:user) { User.create(first_name: 'Test', last_name: 'Ing', email: 'test@ing.com', password: 'password') }
  context 'with correct login information' do
    it 'can login' do
      visit new_session_path
      fill_in('email', with: user.email)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      expect(page).to have_content 'Welcome, Test.'
    end
    it 'but wrong case' do
      visit new_session_path
      fill_in('email', with: user.email.upcase)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path). to eq dashboard_path
      expect(page).to have_content 'Welcome, Test.'
    end
  end
  context 'with incorrect login information' do
    it 'rejects login' do
      visit new_session_path
      fill_in('email', with: user.email)
      fill_in('password', with: user.first_name)
      click_on 'Log In'

      expect(current_path).to eq sessions_path
      expect(page).to have_content 'Email or password is invalid'
    end
  end
end
