require 'rails_helper'

describe 'editing a user' do
  context 'with a correct current password and a' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'Hi', email: 'emmmaiil@raa.zzz', password: '8930nc89fadsfhhdufdasdfshi4sa') }
    it 'valid first and last name' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'name_user_first_name', with: user.first_name + 't'
      fill_in 'name_user_last_name', with: user.last_name + 'a'
      # Finds the 'Current Password' field within the name_edit_user form
      find("[id^=name_edit_user]").fill_in 'Current Password', with: user.password
      click_on 'Update Name'

      expect(page).to have_content 'Name successfully updated.'
      expect(page).to have_content "Name: #{user.first_name + 't'} #{user.last_name + 'a'}"
    end

    it 'valid email' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'Email', with: user.email + 'TTT'
      # Finds the 'Current Password' field within the email_edit_user form
      find("[id^=email_edit_user]").fill_in 'Current Password', with: user.password
      click_on 'Update Email'

      expect(page).to have_content 'Email successfully updated.'
      expect(page).to have_content "Email: #{user.email + 'ttt'}"
    end

    it 'valid new password and confirmation' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'password_new', with: user.password + 't34fa'
      fill_in 'password_new_confirmation', with: user.password + 't34fa'
      fill_in 'current_password', with: user.password
      click_on 'Update Password'

      expect(page).to have_content 'Password successfully updated.'
      click_on 'Back to Dashboard'
      click_on 'Sign Out'
      click_on 'Log In'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password + 't34fa'
      click_on 'Log In'

      expect(page).to have_content "Welcome, #{user.first_name}."
    end
  end

  context 'with a correct current password and a blank' do
    let(:user) { User.create(first_name: 'Ra', last_name: 'Zz', username: 'zzRa', email: 'mmmaiil@raa.zzz', password: '8930nc89fhhdufdshi6hgs') }
    it 'first and last name' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'First name', with: ''
      fill_in 'Last name', with: ''
      # Finds the 'Current Password' field within the name_edit_user form
      find("[id^=name_edit_user]").fill_in 'Current Password', with: user.password
      click_on 'Update Name'

      expect(page).to have_content 'An error occurred, please try again.'
    end

    it 'email' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'Email', with: ''
      # Finds the 'Current Password' field within the email_edit_user form
      find("[id^=email_edit_user]").fill_in 'Current Password', with: user.password
      click_on 'Update Email'

      expect(page).to have_content 'An error occurred, please try again.'
    end

    it 'new password and confirmation' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'password_new', with: ''
      fill_in 'password_new_confirmation', with: ''
      fill_in 'current_password', with: user.password
      click_on 'Update Password'

      expect(page).to have_content 'An error occurred, please try again.'
    end
  end

  context 'with an incorrect current password and a' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'zzzRaa', email: 'emmmaiil@raa.zzz', password: '8930nc89fhhdufdshi4sa') }
    it 'valid first and last name' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'First name', with: user.first_name + 't'
      fill_in 'Last name', with: user.last_name + 'a'
      # Finds the 'Current Password' field within the name_edit_user form
      find("[id^=name_edit_user]").fill_in 'Current Password', with: user.password + 'asd;hfio'
      click_on 'Update Name'

      expect(page).to have_no_content 'Name successfully updated.'
      expect(page).to have_no_content "Name: #{user.first_name + 't'} #{user.last_name + 'a'}"
      expect(page).to have_content 'An error occurred, please try again.'
    end

    it 'valid email' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'Email', with: user.email + 't'
      # Finds the 'Current Password' field within the email_edit_user form
      find("[id^=email_edit_user]").fill_in 'Current Password', with: user.password + 'ph91h'
      click_on 'Update Email'

      expect(page).to have_no_content 'Email successfully updated.'
      expect(page).to have_no_content "Email: #{user.email + 't'}"
      expect(page).to have_content 'An error occurred, please try again.'
    end

    it 'valid new password and confirmation' do
      sign_in(user)
      click_on 'Profile'
      expect(page).to have_link 'Update Your Information'
      click_on 'Update Your Information'

      fill_in 'password_new', with: user.password + 't34fa'
      fill_in 'password_new_confirmation', with: user.password + 't34fa'
      fill_in 'current_password', with: user.password + 'asjdhfash'
      click_on 'Update Password'

      expect(page).to have_content 'An error occurred, please try again.'
      expect(page).to have_no_content 'Password successfully updated.'

      click_on 'Back to Profile'
      click_on 'Back to Dashboard'
      click_on 'Sign Out'
      click_on 'Log In'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log In'

      expect(page).to have_content "Welcome, #{user.first_name}."
    end
  end

  context 'when another user has' do
    it 'the same email address'

  end
end
