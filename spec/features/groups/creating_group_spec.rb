require 'rails_helper'

describe 'group creation' do
  context 'created with' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'ZzzRaa', email: 'email@raa.zzz', password: 'pas1203489y132809hspa1203489y132809hss1203489y132809h') }
    let(:group_info) { Group.create(name: 'This is one awesome group!', description: 'What a description', gift_due_date: '2019-02-28') }
    it 'correct information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_group_path
      fill_in('group_name', with: group_info.name)
      fill_in('group_description', with: group_info.description)
      fill_in('group_gift_due_date', with: group_info.gift_due_date)
      click_on 'Create Group'

      expect(page).to have_content group_info.name
      expect(page).to have_content group_info.description
      expect(page).to have_content group_info.gift_due_date.to_formatted_s(:long_ordinal)
    end

    it 'correct information with dollar limit' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_group_path
      fill_in('group_name', with: group_info.name)
      fill_in('group_description', with: group_info.description)
      fill_in('group_gift_due_date', with: group_info.gift_due_date)
      fill_in('group_dollar_limit', with: 23.47)
      click_on 'Create Group'

      expect(page).to have_content group_info.name
      expect(page).to have_content group_info.description
      expect(page).to have_content group_info.gift_due_date.to_formatted_s(:long_ordinal)
      expect(page).to have_content display_money(23.47)
    end

    it 'blank information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_group_path
      fill_in('group_name', with: '')
      fill_in('group_description', with: '')
      click_on 'Create Group'

      expect(page).to have_content "Name can't be blank, Description can't be blank, and Gift due date can't be blank"
    end
  end

  context 'while' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'ZzzRaa', email: 'email@raa.zzz', password: 'pa1203489y132809hsspa1203489y132809hss') }
    let(:group) { Group.create(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }

    it 'logged in' do
      sign_in(user)

      expect(current_path).to eq dashboard_path
      expect(page).to have_content "Welcome #{user.first_name}"
      click_on 'Create a Group'

      expect(current_path).to eq new_group_path
      fill_in('Name', with: group.name)
      fill_in('Description', with: group.description)
      fill_in('group_gift_due_date', with: group.gift_due_date.to_default_s)
      click_on 'Create Group'

      expect(page).to have_content group.name
      expect(page).to have_content group.description
      expect(page).to have_content group.gift_due_date.to_formatted_s(:long_ordinal)
      expect(page).to have_content 'Edit', 'Delete'
      expect(page).to have_content "#{user.first_name} #{user.last_name}:"
      expect(page).to have_content 'Send an invitation', 'My Wish List'
    end

    it 'not logged in' do
      visit profile_path
      expect(current_path).to eq root_path
      expect(page).to have_content 'You need to be logged in first.'
    end
  end
end
