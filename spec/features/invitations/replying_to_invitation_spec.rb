require 'rails_helper'

describe 'replaying to an invitation' do
  let(:group) { Group.create(name: 'Gift giving', description: 'We love gifts', gift_due_date: '2019-01-01') }
  let(:owner) { User.create(first_name: 'Ray', last_name: 'Lee', email: 'email@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:invitee) { User.create!(first_name: 'Lee', last_name: 'Ray', email: 'lee@ray.com', password: 'pas1203489y132809h132809hss1203489y132spa1203489y809h') }

  it 'by accepting' do
    sign_in_as(owner)
    click_on 'Create a Group'
    create_group(group)
    click_on 'Create Group'
    visit user_path(invitee.id)
    page.select group.name, from: 'invitation[group_id]'
    fill_in 'invitation[comment]', with: 'Would you like to join?'
    click_on 'Submit'
    expect(page).to have_content 'Invitation sent.'
    visit dashboard_path
    click_on 'Sign Out'

    visit root_path
    sign_in_as(invitee)
    expect(current_path).to eq dashboard_path
    expect(page).to have_content "#{owner.first_name} #{owner.last_name} has invited you to join the group #{group.name}!"
    expect(page).to have_content 'Accept', 'Decline'
    click_on 'Accept'

    expect(page).to have_content "Invitation accepted."
    expect(page).to have_link group.name
    expect(page).to have_content group.description  
    click_on group.name

    # might change over time:
    expect(page).to have_content "#{owner.first_name} #{owner.last_name}: Profile Wish List (Group Owner)"
    expect(page).to have_content "#{invitee.first_name} #{invitee.last_name}:"
    expect(page).to have_link "View your Wish List"
  end

  it 'by declining' do
    sign_in_as(owner)
    click_on 'Create a Group'
    create_group(group)
    click_on 'Create Group'
    visit user_path(invitee.id)
    page.select group.name, from: 'invitation[group_id]'
    fill_in 'invitation[comment]', with: 'Would you like to join?'
    click_on 'Submit'
    expect(page).to have_content 'Invitation sent.'
    visit dashboard_path
    click_on 'Sign Out'

    visit root_path
    sign_in_as(invitee)
    expect(current_path).to eq dashboard_path
    expect(page).to have_content "#{owner.first_name} #{owner.last_name} has invited you to join the group #{group.name}!"
    expect(page).to have_content 'Accept', 'Decline'
    click_on 'Decline'

    expect(page).to have_content "Invitation declined."
    expect(page).to have_no_content group.name
  end

end
