require 'rails_helper'

describe 'creating an invitation' do
  let(:group) { Group.create(name: 'Gift giving', description: 'We love gifts', gift_due_date: '2019-01-01') }
  let(:owner) { User.create(first_name: 'Ray', last_name: 'Lee', email: 'email@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:invitee) { User.create!(first_name: 'Lee', last_name: 'Ray', email: 'lee@ray.com', password: 'pas1203489y132809h132809hss1203489y132spa1203489y809h') }

  context 'as a group owner' do
    it 'inviting from user profile' do
      sign_in_as(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'

      visit user_path(invitee.id)
      page.select group.name, from: 'invitation[group_id]'
      fill_in 'invitation[comment]', with: 'Would you like to join?'
      click_on 'Submit'

      expect(page).to have_content 'Invitation sent.'
    end

    it 'inviting from group page' do
      sign_in_as(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'

      fill_in 'email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'

      expect(page).to have_content 'Invitation sent.'
    end
  end

  let(:group) { Group.create(name: 'Gift giving', description: 'We love gifts', gift_due_date: '2019-01-01') }
  let(:owner) { User.create(first_name: 'Ray', last_name: 'Lee', email: 'email@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:invitee) { User.create!(first_name: 'Lee', last_name: 'Ray', email: 'lee@ray.com', password: 'pas1203489y132809h132809hss1203489y132spa1203489y809h') }

  context 'not as a group owner' do
    it 'from user profile' do
      sign_in_as(invitee)

      visit user_path(owner.id)
      expect(page).to have_no_content "Invite #{owner.first_name} #{owner.last_name} to a Group", 'Submit'
    end

    it 'from group page' do
      sign_in_as(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      fill_in 'email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent.'
      visit dashboard_path
      click_on 'Sign Out'

      sign_in_as(invitee)
      click_on 'Accept'
      expect(page).to have_no_content 'Send an invitation', 'Submit'

    end
  end
end
