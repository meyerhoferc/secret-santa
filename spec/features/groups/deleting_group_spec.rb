require 'rails_helper'

describe 'deleting a group' do
  context 'with' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'ZzzRaa', email: 'email@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
    let(:group) { Group.create(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }
    let(:item_one) { Item.create(name: 'Wallet', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
    let(:item_two) { Item.create(name: 'Shoes', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }

    it 'no user items' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      page.all('a', exact_text: group.name, visible:true).last.click
      click_on 'Delete'

      expect(page).to have_content "Group #{group.name} deleted!"
      expect(page).to have_no_link group.name
    end

    it 'one user items' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      page.all('a', exact_text: group.name, visible:true).last.click
      click_on 'My Wish List'
      create_item(item_one)
      click_on 'Create Item'
      page.all('a', exact_text: group.name, visible:true).last.click

      click_on 'Delete'
      expect(page).to have_content"Group #{group.name} deleted!"
      expect(page).to have_no_link group.name
    end

    it 'many user items' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      page.all('a', exact_text: group.name, visible:true).last.click

      click_on 'My Wish List'
      create_item(item_one)
      click_on 'Create Item'
      create_item(item_two)
      click_on 'Create Item'
      page.all('a', exact_text: group.name, visible:true).last.click

      click_on 'Delete'
      expect(page).to have_content "Group #{group.name} deleted!"
      expect(page).to have_no_link group.name
    end
  end
end
