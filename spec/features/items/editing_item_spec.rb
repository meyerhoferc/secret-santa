require 'rails_helper'

describe 'editing an item' do
  context 'with' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'ZzzRaa', email: 'emaiil@raa.zzz', password: 'pass1203489y132809hsfduhpass') }
    let(:group) { Group.create(name: 'The best group there is', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }
    let(:item_one) { Item.create(name: 'Wallet', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
    let(:item_two) { Item.create(name: 'Shoes', description: 'So pretty!', size: 'L', note: 'I would like many of these please.') }

    it 'correct information' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      click_on group.name
      click_on 'View your Wish List'
      click_on 'Add an item to your wish list'
      create_item(item_one)
      click_on 'Create Item'

      expect(page).to have_link item_one.name
      click_on item_one.name
      click_on 'Edit Item'

      edit_item(item_one)
      click_on 'Update Item'

      expect(page).to have_content item_one.name + '!!'
      expect(page).to have_content item_one.description + '!!'
      expect(page).to have_content item_one.size + '!!'
      expect(page).to have_content item_one.note + '!!'
    end

    it 'blank information' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      click_on group.name
      click_on 'View your Wish List'
      click_on 'Add an item to your wish list'
      click_on 'Create Item'

      expect(page).to have_content "Name can't be blank and Description can't be blank"
    end

    it 'multiple items' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      click_on group.name
      click_on 'View your Wish List'
      click_on 'Add an item to your wish list'
      create_item(item_one)
      click_on 'Create Item'

      expect(page).to have_link item_one.name
      click_on 'Add an item to your wish list'
      create_item(item_two)
      click_on 'Create Item'

      expect(page).to have_link item_two.name
      click_on item_one.name
      item_page_content(item_one)

      click_on 'Back to List'
      click_on item_two.name
      item_page_content(item_two)
    end
  end

  context 'attempt for' do
    let(:user_one) { User.create!(first_name: 'Raa', last_name: 'Zzrz', username: 'adffd', email: 'email@raa.zzzggg', password: 'pas1203489y132809hspas1203489y132809hs') }
    let(:user_two) { User.create!(first_name: 'Aaa', last_name: 'Zzrz', username: '23r4d', email: 'emaaaail@raa.zzz', password: 'pas1203489y132809hspas1203489y132809hs') }
    let(:group) { Group.create!(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31', owner_id: user_one.id) }
    let(:list) { List.create!(user_id: user_one.id, group_id: group.id) }
    let(:item) { Item.create!(name: 'Wallet', description: 'So pretty', size: 'XL', note: 'I would like many of these.', list_id: list.id) }
    it 'another user' do
      sign_in(user_two)
      visit "/groups/#{group.id}/lists/#{list.id}/items/#{item.id}/edit"
      expect(page).to have_content "Action is unauthorized."
    end
  end
end
