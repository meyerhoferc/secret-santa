require 'rails_helper'

describe 'editing a group' do
  context 'with' do
    let(:user) { User.create(first_name: 'Raa', last_name: 'Zzz', username: 'ZzzRaa', email: 'email@raa.zzz', password: 'pa1203489y132809hsspa1203489y132809hss') }
    let(:group) { Group.create(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31') }

    it 'correct information' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path

      expect(page).to have_link group.name
      page.all('a', exact_text: group.name, visible:true).last.click
      click_on 'Edit'

      fill_in 'Name', with: group.name + '!!'
      fill_in 'Description', with: group.description + '!!'
      fill_in 'group_gift_due_date', with: group.gift_due_date.next.to_default_s
      click_on 'Update Group'

      expect(page).to have_content group.name + '!!'
      expect(page).to have_content group.description + '!!'
      expect(page).to have_content group.gift_due_date.next.to_formatted_s(:long_ordinal)

    end

    it 'blank information' do
      sign_in(user)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      visit dashboard_path
      page.all('a', exact_text: group.name, visible:true).last.click
      click_on 'Edit'

      fill_in 'Name', with: ''
      fill_in 'Description', with: ''
      fill_in 'group_gift_due_date', with: ''
      click_on 'Update Group'

      expect(page).to have_content "Name can't be blank, Description can't be blank, and Gift due date can't be blank"
    end
  end

  context 'attempt for' do
    let(:user_one) { User.create!(first_name: 'Raa', last_name: 'Zzz', username: 'aaasd', email: 'email@raa.zzz', password: 'pas1203489y132809hspas1203489y132809hs') }
    let(:user_two) { User.create!(first_name: 'A', last_name: 'Zzrz', username: 'afdsasd', email: 'emaaaail@raa.zzz', password: 'pas1203489y132809hspas1203489y132809hs') }
    let(:group) { Group.create!(name: 'My first group creation', description: 'Whoever wants to join', gift_due_date: '2018/12/31', owner_id: user_one.id) }
    it 'another user' do
      sign_in(user_two)
      visit "/groups/#{group.id}/edit"
      expect(page).to have_content "Action is unauthorized."
    end
  end
end
