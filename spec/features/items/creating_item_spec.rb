require 'rails_helper'

describe 'item creation' do
  context 'with' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'ZzzrrRaa', email: 'email@raa.zzz', password: 'pas1203489y132809hspas1203489y132809hs') }
    let(:user_two) { User.create(first_name: 'A', last_name: 'Zzrz', username: 'ZzzRaa', email: 'emaaaail@raa.zzz', password: 'pas1203489y132809hspas1203489y132809hs') }
    let(:group) { Group.create(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }
    let(:item_one) { Item.create(name: 'Wallet', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
    let(:item_two) { Item.create(name: 'Shoes', description: 'So pretty!', size: 'L', note: 'I would like many of these please.') }

    it 'correct information' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      page.all('a', exact_text: group.name, visible:true).last.click
      click_on 'My Wish List'
      create_item(item_one)
      click_on 'Create Item'

      expect(page).to have_link item_one.name
      click_on item_one.name

      expect(page).to have_content item_one.name
      expect(page).to have_content item_one.description
      expect(page).to have_content item_one.size
      expect(page).to have_content item_one.note
    end

    it 'blank information' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      page.all('a', exact_text: group.name, visible:true).last.click
      click_on 'My Wish List'
      click_on 'Create Item'

      expect(page).to have_content "Name can't be blank and Description can't be blank"
    end

    it 'multiple items' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      page.all('a', exact_text: group.name, visible:true).last.click
      click_on 'My Wish List'
      create_item(item_one)
      click_on 'Create Item'

      expect(page).to have_link item_one.name
      create_item(item_two)
      click_on 'Create Item'

      expect(page).to have_link item_two.name
      click_on item_one.name
      item_page_content(item_one)

      click_on 'Wish List'
      click_on item_two.name
      item_page_content(item_two)
    end
  end

  context 'attempt for' do
    let(:user_one) { User.create!(first_name: 'Raa', last_name: 'Zzz', username: 'adsdf', email: 'email@raa.zzz', password: 'pas1203489y132809hspas1203489y132809hs') }
    let(:user_two) { User.create!(first_name: 'A', last_name: 'Zzrz', username: 'adsf', email: 'emaaaail@raa.zzz', password: 'pas1203489y132809hspas1203489y132809hs') }
    let(:group) { Group.create!(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31', owner_id: user_one.id) }
    let(:list) { List.create!(user_id: user_one.id, group_id: group.id) }
    it 'another user' do
      sign_in(user_two)
      visit "/groups/#{group.id}/lists/#{list.id}/"
      expect(page).to have_no_content "Add item to wish list"
    end
  end
end
