require 'rails_helper'

describe 'deleting a group' do
  context 'with' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'ZzzRaa', email: 'email@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
    let(:user_two) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'Zzzraa', email: 'emailss@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
    let(:user_three) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'Zsdfzzraa', email: 'emadfsailss@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
    let(:group) { Group.create(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }
    let(:item_one) { Item.create(name: 'Wallet', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
    let(:item_two) { Item.create(name: 'Shoes', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
    let(:list) { List.create(group_id: group.id, user_id: user.id) }

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

    let(:owner) { User.create!(first_name: 'Raa', last_name: 'Zzz', username: 'ZzzRdsfaa', email: 'emasdfdsfil@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
    let(:user_four) { User.create!(first_name: 'Raa', last_name: 'Zzz', username: 'Zzzrdsfaa', email: 'emadfdsdfilss@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
    let(:user_five) { User.create!(first_name: 'Raa', last_name: 'Zzz', username: 'Zsdfzfddfzraa', email: 'emaaasdfdfsailss@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
    let(:group_two) { Group.create!(name: 'My first group creation aagain', description: 'Whoever wants to join', gift_due_date: '2018/12/31', owner_id: owner.id) }
    let(:item_three) { Item.create(name: 'Wallet', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
    let(:item_four) { Item.create(name: 'Shoes', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
    let(:list_two) { List.create!(group_id: group_two.id, user_id: owner.id) }

    it 'many user items and santa assignments' do
      owner.groups << group_two
      owner.lists << list_two
      sign_in(owner)
      page.all('a', exact_text: group_two.name, visible:true).last.click
      click_on 'My Wish List'
      create_item(item_three)
      click_on 'Create Item'
      create_item(item_four)
      click_on 'Create Item'
      page.all('a', exact_text: group_two.name, visible:true).last.click

      owner_invites_to_group(user_four, group_two)
      owner_invites_to_group(user_five, group_two)
      accept_invitation(user_four)
      accept_invitation(user_five)
      sign_out_and_log_in(owner)
      visit group_path(group_two.id)
      click_on 'Assign Secret Santas'
      expect(page).to have_content 'Santa Assignments Complete!'
      click_on 'Delete'
      expect(page).to have_content "#{group_two.name} deleted!"
    end
  end
end
