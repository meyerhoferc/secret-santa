require 'rails_helper'

describe 'a group is' do
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
