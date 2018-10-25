require 'rails_helper'

describe 'group creation' do

  context 'created' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'passpass') }
    let(:group_info) { Group.create(name: 'This is one awesome group!', description: 'What a description', gift_due_date: '2019-02-28') }
    it 'correctly' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_group_path
      fill_in('group_name', with: group_info.name)
      fill_in('group_description', with: group_info.description)
      fill_in('group_gift_due_date', with: group_info.gift_due_date)
      click_on 'Create Group'

      expect(page).to have_content group_info.name
      expect(page).to have_content group_info.description
      expect(page).to have_content group_info.gift_due_date
    end

    it 'incorrectly' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_group_path
      fill_in('group_name', with: '')
      fill_in('group_description', with: '')
      click_on 'Create Group'

      expect(page).to have_content "The Gift Due Date can't be blank, or the Group Name is already taken."
    end
  end

  context 'while' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'passpass') }
    let(:group) { Group.create(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }

    it 'logged in' do
      sign_in_as(user)

      expect(current_path).to eq dashboard_path
      expect(page).to have_content 'Welcome, Raa.'
      click_on 'Create a Group'

      expect(current_path).to eq new_group_path
      fill_in('Name', with: group.name)
      fill_in('Description', with: group.description)
      fill_in('Gift Due Date', with: group.gift_due_date.to_default_s)
      click_on 'Create Group'

      expect(page).to have_content group.name
      expect(page).to have_content group.description
      expect(page).to have_content group.gift_due_date.to_default_s
      expect(page).to have_content 'Edit Group', 'Delete Group'
      expect(page).to have_content "#{user.first_name} #{user.last_name}:"
      expect(page).to have_content '(Group Owner)'
      expect(page).to have_content 'Send an invitation', 'View your Wish List'
    end

    it 'logged out' do
      visit profile_path
      expect(current_path).to eq root_path
      expect(page).to have_content 'You must be logged in first.'
    end
  end

  context 'visible only' do
    let(:user_one) { User.create(first_name: 'Johnny', last_name: 'Jy', email: 'johanna@test.com', password: 'pass') }
    let(:user_two) { User.create(first_name: 'Johanna', last_name: 'Ja', email: 'johnny@test.com', password: 'pass') }
    let(:group_one) { Group.create(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }
    let(:group_two) { Group.create(name: 'My second group creation', description: 'Whoever wants to join', gift_due_date: '2019/12/31') }
    it 'to one user' do
      sign_in_as(user_one)
      expect(current_path).to eq dashboard_path
      click_on 'Create a Group'
      expect(current_path).to eq new_group_path
      fill_in('Name', with: group_one.name)
      fill_in('Description', with: group_one.description)
      fill_in('Gift Due Date', with: group_one.gift_due_date.to_default_s)
      click_on 'Create Group'

      sign_in_as(user_two)
      expect(current_path).to eq dashboard_path
      click_on 'Create a Group'
      expect(current_path).to eq new_group_path
      fill_in('Name', with: group_two.name)
      fill_in('Description', with: group_two.description)
      fill_in('Gift Due Date', with: group_two.gift_due_date.to_default_s)
      click_on 'Create Group'

      visit dashboard_path
      expect(page).to have_content group_two.name, user_two.first_name
      expect(page).to have_no_content group_one.name, user_one.first_name
    end
  end
end
