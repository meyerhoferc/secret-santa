require 'rails_helper'

describe 'group creation' do
  before { @user = User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'passpass') }
  context 'created' do
    it 'correctly' do
      @group_info = { name: 'This is one awesome group!',
                      description: 'What a description',
                      due_date: '2019-02-28' }
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit new_group_path
      fill_in('group_name', with: @group_info[:name])
      fill_in('group_description', with: @group_info[:description])
      fill_in('group_gift_due_date', with: @group_info[:due_date])
      click_on 'Create Group'

      expect(page).to have_content "#{@group_info[:name]}"
      expect(page).to have_content "#{@group_info[:description]}"
      expect(page).to have_content "#{@group_info[:due_date]}"
    end

    it 'incorrectly' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit new_group_path
      fill_in('group_name', with: '')
      fill_in('group_description', with: '')
      click_on 'Create Group'

      expect(page).to have_content "The Gift Due Date can't be blank, or the Group Name is already taken."
    end
  end
end
