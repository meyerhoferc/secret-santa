require 'rails_helper'

describe "user login" do
  let(:user) { User.create(first_name: 'Test', last_name: 'Ing', username: 'ingTest', email: 'test@ing.com', password: 'pas1203489y132809hswo1203489y132809hrd') }
  context 'with email' do
    it 'correctly' do
      visit new_session_path
      fill_in('email', with: user.email)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      expect(page).to have_content 'Welcome Test'
    end

    it 'correctly but wrong case' do
      visit new_session_path
      fill_in('username_email', with: user.email.upcase)
      fill_in('password', with: user.password)
      click_on 'Log In'

      expect(current_path). to eq dashboard_path
      expect(page).to have_content 'Welcome Test'
    end

    it 'incorrect password' do
      visit new_session_path
      fill_in('email', with: user.email)
      fill_in('password', with: user.first_name)
      click_on 'Log In'

      expect(current_path).to eq sessions_path
      expect(page).to have_content 'Username, Email or password invalid.'
      expect(page).to have_link 'Home'
    end
  end

  context 'with username' do
    let(:user) { User.create(first_name: 'Test', last_name: 'Ing', username: 'ingtest', password: 'pas1203489y132809hswo1203489y132809hrd') }
    it 'correctly' do
      sign_in_username(user)

      expect(page).to have_content 'Welcome Test'
      expect(current_path).to eq dashboard_path
    end

    it 'correctly but wrong case' do
      visit login_path
      fill_in 'Username or email', with: user.username.upcase
      fill_in 'Password', with: user.password
      click_on 'Log In'

      expect(page).to have_content 'Welcome Test'
      expect(current_path).to eq dashboard_path
    end


    it 'incorrect password' do
      visit login_path
      fill_in 'Username or email', with: user.username.upcase
      fill_in 'Password', with: user.password + '6'
      click_on 'Log In'

      expect(page).to have_content 'Username, Email or password invalid.'
    end
  end
end
