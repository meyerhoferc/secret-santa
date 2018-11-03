require 'rails_helper'

xdescribe 'groups' do
  before { @user = User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'passpass') }
  context 'are created' do
    it 'correctly' do
      @group_info = { name: 'This sdfis one adwesome grfoup', description: 'What a description' }
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit new_group_path
      fill_in('group_name', with: @group_info[:name])
      fill_in('group_description', with: @group_info[:description])
      click_on 'Create Group'
      expect(page).to have_content "#{@group_info[:name]}"
      expect(page).to have_content "#{@group_info[:description]}"

    end
  end
end
