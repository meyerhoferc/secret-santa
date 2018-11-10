require 'rails_helper'

describe 'user signup' do
  context 'a new user' do
    let(:user) { {first_name: 'Joey', last_name: 'Ralf', username: 'jraasdflf', email: 'emati@l.com', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs' } }
    it 'can create an account' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_in('user[first_name]', with: user[:first_name])
      fill_in('user[last_name]', with: user[:last_name])
      fill_in('user[username]', with: user[:username])
      fill_in('user[email]', with: user[:email])
      fill_in('user[password]', with: user[:password])
      fill_in('user[password_confirmation]', with: user[:password])
      expect(page).to have_link 'Back to Homepage'
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('Username or email', with: user[:email])
      fill_in('Password', with: user[:password])
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      expect(page).to have_content "Welcome #{user[:first_name]}"
      expect(page).to have_link 'Sign Out'
      expect(page).to have_link 'Profile'
      expect(page).not_to have_link 'Log In'
      expect(page).not_to have_link 'Sign Up'
    end
  end

  context 'incorrectly with' do
    let(:user_one) { {first_name: 'Joey', last_name: 'Ralf', username: 'jrsdflff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs'} }
    let(:user_two) { User.create(first_name: 'Joey', last_name: 'Ralf', username: 'jrsdflff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs') }
    let(:user_three) { {first_name: 'Joey', last_name: 'Ralf', username: 'jrsdflff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs'} }
    let(:user_four) { User.create(first_name: 'Joey', last_name: 'Ralf', email: 'My@test.com', username: 'jrsdflff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs') }

    it 'blank credentials' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path

      click_on 'Create User'

      expect(page).to have_content "First name can't be blank, First name must contain only letters, apostrophes or dashes, Last name can't be blank, Last name must contain only letters, apostrophes or dashes, Username can't be blank, Username must contain only letters, numbers or underscores, Password can't be blank, and Password is too weak"
      expect(current_path).to eq signup_path
    end

    it 'blank username' do
      visit root_path
      click_on 'Sign Up'
      fill_in('user[first_name]', with: user_one[:first_name])
      fill_in('user[last_name]', with: user_one[:last_name])
      fill_in('user[email]', with: user_one[:email])
      fill_in('user[password]', with: user_one[:password])
      fill_in('user[password_confirmation]', with: user_one[:password])
      click_on 'Create User'

      expect(page).to have_content "Username can't be blank and Username must contain only letters, numbers or underscores"
    end

    it 'same username' do
      user_two
      visit root_path
      click_on 'Sign Up'
      fill_in('user[first_name]', with: user_one[:first_name])
      fill_in('user[last_name]', with: user_one[:last_name])
      fill_in('user[username]', with: user_one[:username])
      fill_in('user[email]', with: user_one[:email])
      fill_in('user[password]', with: user_one[:password])
      fill_in('user[password_confirmation]', with: user_one[:password])
      click_on 'Create User'

      expect(page).to have_content "Username has already been taken"
    end

    it 'same email' do
      user_four
      visit root_path
      click_on 'Sign Up'
      fill_in('user[first_name]', with: user_three[:first_name])
      fill_in('user[last_name]', with: user_three[:last_name])
      fill_in('user[email]', with: user_four[:email])
      fill_in('user[password]', with: user_three[:password])
      fill_in('user[password_confirmation]', with: user_three[:password])
      click_on 'Create User'

      expect(page).to have_content "Username can't be blank, Username must contain only letters, numbers or underscores, and Email has already been taken"
    end

    it 'same email case insensitive' do
      user_four
      visit root_path
      click_on 'Sign Up'
      fill_in('user[first_name]', with: user_three[:first_name])
      fill_in('user[last_name]', with: user_three[:last_name])
      fill_in('user[email]', with: user_four[:email].upcase)
      fill_in('user[password]', with: user_three[:password])
      fill_in('user[password_confirmation]', with: user_three[:password])
      click_on 'Create User'

      expect(page).to have_content "Username can't be blank, Username must contain only letters, numbers or underscores, and Email has already been taken"
    end

    it 'invalid email format' do
      u = User.create(first_name: 'Josh', last_name: 'Flaf', email: 'test@email@email', username: 'jrsdf43lff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs')
      expect(u.valid?).to eq false
      v = User.create(first_name: 'Josh', last_name: 'Flaf', email: 'test@email.email', username: 'jrsdff78lff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs')
      expect(v.valid?).to eq true
      w = User.create(first_name: 'Josh', last_name: 'Flaf', email: 't@e.em', username: 'jrsdfa123sdflff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs')
      expect(w.valid?).to eq true
      x = User.create(first_name: 'Josh', last_name: 'Flaf', email: 'testing@email.c0m', username: 'jrsdffdsa67lff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs')
      expect(x.valid?).to eq false
      y = User.create(first_name: 'Josh', last_name: 'Flaf', email: 'te234st@emadds45il.email', username: 'jrasdfsd4445flff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs')
      expect(y.valid?).to eq true
      z = User.create(first_name: 'Josh', last_name: 'Flaf', email: 'test@email-me-today.co.uk', username: 'jrsd545flfdaff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs')
      expect(z.valid?).to eq true
    end
  end

  context 'with a username' do
    let(:user_one) { {first_name: 'Joey', last_name: 'Ralf', username: 'jradf4sdflff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs'} }
    let(:user_two) { User.create(first_name: 'Joey', last_name: 'Ralf', username: 'jrsdflff', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs') }
    it 'and no email' do
      visit root_path
      click_on 'Sign Up'
      fill_in('user[first_name]', with: user_one[:first_name])
      fill_in('user[last_name]', with: user_one[:last_name])
      fill_in('user[username]', with: user_one[:username])
      fill_in('user[password]', with: user_one[:password])
      fill_in('user[password_confirmation]', with: user_one[:password])
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
    end

    it 'and an email' do
      visit root_path
      click_on 'Sign Up'
      fill_in('user[first_name]', with: user_one[:first_name])
      fill_in('user[last_name]', with: user_one[:last_name])
      fill_in('user[username]', with: user_one[:username])
      fill_in('user[email]', with: 'email@my.com')
      fill_in('user[password]', with: user_one[:password])
      fill_in('user[password_confirmation]', with: user_one[:password])
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
    end

    it 'multiple users blank emails' do
      user_two
      visit root_path
      click_on 'Sign Up'
      fill_in('user[first_name]', with: user_one[:first_name])
      fill_in('user[last_name]', with: user_one[:last_name])
      fill_in('user[username]', with: user_one[:username])
      fill_in('user[password]', with: user_one[:password])
      fill_in('user[password_confirmation]', with: user_one[:password])
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
    end

    it 'signup uppercase, login mixed-case' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: user_one[:username].upcase
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: 'jRaDf4SdFlFf'
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end

    it 'signup uppercase, login uppercase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: user_one[:username].upcase
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: user_one[:username].upcase
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end

    it 'signup uppercase, login downcase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: user_one[:username].upcase
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: user_one[:username].downcase
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end

    it 'signup mixed-case, login mixed-case' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: 'jRAdf4SDFlFf'
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: 'jRAdf4SDFlFf'
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end

    it 'signup mixed-case, login uppercase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: 'jRAdf4SDFlFf'
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: user_one[:username].upcase
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end

    it 'signup mixed-case, login downcase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: 'jRAdf4SDFlFf'
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: user_one[:username].downcase
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end

    it 'signup downcase, login mixed-case' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: user_one[:username].downcase
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: 'jRAdf4SDfLfF'
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end

    it 'signup downcase, login uppercase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: user_one[:username].downcase
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: user_one[:username].upcase
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end

    it 'signup downcase, login downcase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user_one)
      fill_in 'user[username]', with: user_one[:username].downcase
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
      expect(current_path).to eq login_path
      visit login_path
      fill_in 'Username or email', with: user_one[:username].downcase
      fill_in 'Password', with: user_one[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user_one)
    end
  end

  context 'with an email' do
    let(:user) { {first_name: 'Joey', last_name: 'Ralf', username: 'jradf4sdflff', email: 'eMaIl@EmAiL.emaILE', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs'} }
    it 'signup uppercase, login mixed-case' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in 'user[email]', with: user[:email].upcase
      click_on 'Create User'

      expect(page).to have_content 'Account successfully created.'
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
      fill_in 'user[email]', with: user[:email].upcase
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in 'email', with: user[:email].upcase
      fill_in 'password', with: user[:password]
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup uppercase, login downcase' do
      visit root_path
      click_on 'Sign Up'

      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user[:email].upcase)
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user[:email].downcase)
      fill_in('password', with: user[:password])
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup mixed-case, login mixed-case' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user[:email])
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
      fill_in('user[email]', with: user[:email])
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user[:email].upcase)
      fill_in('password', with: user[:password])
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup mixed-case, login downcase' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user[:email])
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user[:email].downcase)
      fill_in('password', with: user[:password])
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup downcase, login mixed-case' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user[:email].downcase)
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
      fill_in('user[email]', with: user[:email].downcase)
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user[:email].upcase)
      fill_in('password', with: user[:password])
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end

    it 'signup downcase, login downcase' do
      visit root_path
      click_on 'Sign Up'
      expect(current_path).to eq signup_path
      fill_out_user_signup_no_email(user)
      fill_in('user[email]', with: user[:email].downcase)
      click_on 'Create User'

      expect(current_path).to eq login_path
      fill_in('email', with: user[:email].downcase)
      fill_in('password', with: user[:password])
      click_on 'Log In'

      expect(current_path).to eq dashboard_path
      dashboard_path_content(user)
    end
  end

  context 'as an existing, logged in user' do
    it 'redirects from /signup to dashboard' do
      u = User.create(first_name: 'Raa', last_name: 'Zzz', username: 'rasdfzzz', email: 'email@raa.zzz', password: 'pa1203489y132809hssp1203489y132809hass')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(u)
      visit signup_path
      expect(current_path).to eq dashboard_path
    end
  end
end
