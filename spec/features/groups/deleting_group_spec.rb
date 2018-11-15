require 'rails_helper'

describe 'deleting a group' do
  context 'with' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', email: 'email@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
    let(:group) { Group.create(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }
    let(:item_one) { Item.create(name: 'Wallet', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
    let(:item_two) { Item.create(name: 'Shoes', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }


    it 'no user items' do
      sign_in_as(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      click_on group.name
      click_on 'Delete Group'

      expect(page).to have_content 'Group Deleted!'
      expect(page).to have_no_content group.name
    end

    it 'one user items' do
      sign_in_as(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      click_on group.name
      click_on 'View your Wish List'
      click_on 'Add an item to your wish list'
      create_item(item_one)
      click_on 'Create Item'
      click_on 'Back to Group'

      click_on 'Delete Group'
      expect(page).to have_content 'Group Deleted!'
      expect(page).to have_no_content group.name
    end

    it 'many user items' do
      sign_in_as(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      click_on group.name

      click_on 'View your Wish List'
      click_on 'Add an item to your wish list'
      create_item(item_one)
      click_on 'Create Item'
      click_on 'Add an item to your wish list'
      create_item(item_two)
      click_on 'Create Item'
      click_on 'Back to Group'

      click_on 'Delete Group'
      expect(page).to have_content 'Group Deleted!'
      expect(page).to have_no_content group.name
    end
  end
end
