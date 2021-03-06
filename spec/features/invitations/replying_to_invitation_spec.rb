require 'rails_helper'

describe 'replying to an invitation' do
  let(:group) { Group.create(name: 'Gift giving', description: 'We love gifts', gift_due_date: '2019-01-01') }
  let(:owner) { User.create(first_name: 'Ray', last_name: 'Lee', username: 'leeray', email: 'email@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:invitee) { User.create!(first_name: 'Lee', last_name: 'Ray', username: 'raylee', email: 'lee@ray.com', password: 'pas1203489y132809h132809hss1203489y132spa1203489y809h') }

  it 'by accepting' do
    sign_in(owner)
    click_on 'Create a Group'
    create_group(group)
    click_on 'Create Group'
    visit user_path(invitee.id)
    page.select group.name, from: 'invitation[group_id]'
    fill_in 'invitation[comment]', with: 'Would you like to join?'
    click_on 'Submit'
    expect(page).to have_content 'Invitation sent'
    sign_out

    visit root_path
    sign_in(invitee)
    expect(current_path).to eq dashboard_path
    expect(page).to have_content "#{owner.full_name} has invited you to join the group #{group.name}!"
    expect(page).to have_content 'Accept', 'Decline'
    click_on 'Accept'

    expect(page).to have_content 'Invitation accepted'
    expect(page).to have_link group.name
    expect(page).to have_content group.description
    page.all('a', exact_text: group.name, visible:true).last.click

    # might change over time
    expect(page).to have_content "#{owner.full_name}: Wish List"
    expect(page).to have_content "#{invitee.full_name}:"
    expect(page).to have_link 'My Wish List'
  end

  it 'by declining' do
    sign_in(owner)
    click_on 'Create a Group'
    create_group(group)
    click_on 'Create Group'
    fill_in 'email', with: invitee.email
    fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
    click_on 'Submit'
    expect(page).to have_content 'Invitation sent'
    sign_out

    sign_in(invitee)
    expect(current_path).to eq dashboard_path
    expect(page).to have_content "#{owner.full_name} has invited you to join the group #{group.name}!"
    expect(page).to have_content 'Accept', 'Decline'
    click_on 'Decline'

    expect(page).to have_content 'Invitation declined'
    expect(page).to have_no_content group.name
  end
end

describe 'owner sending multiple invites' do
  let(:group) { Group.create(name: 'The season to give gifts', description: 'We love gifts more than you know', gift_due_date: '2022-01-01') }
  let(:owner) { User.create(first_name: 'Leaf', last_name: 'Fall', username: 'fallleaf', email: 'email@fall.co', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:invitee) { User.create!(first_name: 'Punkin', last_name: 'Patch', username: 'october', email: 'punkin@october.patch', password: 'pas1203489y132809h132809hss1203489y132spa1203489y809h') }
  let(:user) { User.create!(first_name: 'Lee', last_name: 'Ray', username: 'lasdf', email: 'leasdfe@ray.com', password: 'pas1203489y132809h13280dsfsdsdf9hss1203489y132spa1203489y809h') }

  context 'with email' do
    it 'user declining' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      fill_in 'Username or email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent'
      sign_out

      sign_in(invitee)
      expect(current_path).to eq dashboard_path
      expect(page).to have_content "#{owner.full_name} has invited you to join the group #{group.name}!"
      expect(page).to have_content 'Accept', 'Decline'
      click_on 'Decline'
      expect(page).to have_content 'Invitation declined'
      expect(page).to have_no_content group.name
      sign_out

      sign_in(owner)
      page.all('a', exact_text: group.name, visible:true).last.click
      fill_in 'Username or email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent'

      sign_out
      sign_in(invitee)
      expect(page).to have_content "#{owner.full_name} has invited you to join the group #{group.name}"
    end

    it 'user accepting' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      fill_in 'Username or email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent'
      sign_out

      sign_in(invitee)
      expect(current_path).to eq dashboard_path
      expect(page).to have_content "#{owner.full_name} has invited you to join the group #{group.name}!"
      expect(page).to have_content 'Accept', 'Decline'
      click_on 'Accept'
      expect(page).to have_content 'Invitation accepted'
      expect(page).to have_content group.name
      sign_out

      sign_in(owner)
      page.all('a', exact_text: group.name, visible:true).last.click
      fill_in 'Username or email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Receiver has already been invited to this group'

      sign_out
      sign_in(invitee)
      expect(page).to have_no_content "#{owner.full_name} has invited you to join the group #{group.name}!"
    end
  end

  context 'with username' do
    it 'user declining' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      fill_in 'Username or email', with: invitee.username
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent'
      sign_out

      sign_in(invitee)
      expect(current_path).to eq dashboard_path
      expect(page).to have_content "#{owner.full_name} has invited you to join the group #{group.name}!"
      expect(page).to have_content 'Accept', 'Decline'
      click_on 'Decline'
      expect(page).to have_content 'Invitation declined'
      expect(page).to have_no_content group.name
      sign_out

      sign_in(owner)
      page.all('a', exact_text: group.name, visible:true).last.click
      fill_in 'email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent'

      sign_out
      sign_in(invitee)
      expect(page).to have_content "#{owner.full_name} has invited you to join the group #{group.name}"
    end

    it 'user accepting' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      fill_in 'email', with: invitee.username
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent'
      sign_out

      sign_in(invitee)
      expect(current_path).to eq dashboard_path
      expect(page).to have_content "#{owner.full_name} has invited you to join the group #{group.name}!"
      expect(page).to have_content 'Accept', 'Decline'
      click_on 'Accept'
      expect(page).to have_content 'Invitation accepted'
      expect(page).to have_no_content "#{owner.full_name} has invited you to join the group #{group.name}!"

      sign_out

      sign_in(owner)
      page.all('a', exact_text: group.name, visible:true).last.click
      fill_in 'email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Receiver has already been invited to this group'

      sign_out
      sign_in(invitee)
      expect(page).to have_no_content "#{owner.full_name} has invited you to join the group #{group.name}!"
    end
  end

  context 'for another user' do
    it 'accepting' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      fill_in 'email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent'
      sign_out

      sign_in(user)
      expect(current_path).to eq dashboard_path
      expect(page).to have_no_content "#{owner.full_name} has invited you to join the group #{group.name}!"
      expect(page).to have_no_content 'Accept', 'Decline'
      visit "/accept/#{invitee.invitations_received.first.id}"
      expect(page).to have_content 'Action is unauthorized'

    end

    it 'declining' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'
      fill_in 'email', with: invitee.email
      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'
      expect(page).to have_content 'Invitation sent'
      sign_out

      sign_in(user)
      expect(current_path).to eq dashboard_path
      expect(page).to have_no_content "#{owner.full_name} has invited you to join the group #{group.name}!"
      expect(page).to have_no_content 'Accept', 'Decline'
      visit "/decline/#{invitee.invitations_received.first.id}"
      expect(page).to have_content 'Action is unauthorized'
    end
  end
end
