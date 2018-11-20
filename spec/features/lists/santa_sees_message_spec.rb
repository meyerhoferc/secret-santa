require 'rails_helper'

describe 'santa messages visible' do
  context 'to each santa' do
    let(:o_1) { User.create!(first_name: 'OwnerOne', last_name: 'One', username: 'owner1', email: 'email1@own.er', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_1) { User.create!(first_name: 'RayOne', last_name: 'LeeOne', username: 'leeray1', email: 'email1@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_2) { User.create!(first_name: 'RayTwo', last_name: 'LeeTwo', username: 'leeray2', email: 'email2@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_3) { User.create!(first_name: 'RayThree', last_name: 'LeeThree', username: 'leeray3', email: 'email3@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_4) { User.create!(first_name: 'RayFour', last_name: 'LeeFour', username: 'leeray4', email: 'email4@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_5) { User.create!(first_name: 'RayFive', last_name: 'LeeFive', username: 'leeray5', email: 'email5@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:g_1) { Group.create(name: 'This Is One long Test Setupp', description: 'Why did I do it this way?', gift_due_date: '2023-01-01', owner_id: o_1.id) }
    let(:e_t_1) { ExclusionTeam.create(group_id: g_1.id, name: 'Team One!!') }
    let(:e_t_2) { ExclusionTeam.create(group_id: g_1.id, name: 'Team Two!!') }
    let(:l_1) { List.create(group_id: g_1.id, user_id: o_1.id) }

    before { @users = [u_1, u_2, u_3, u_4, u_5] }
    before { @teams = [e_t_1, e_t_2] }

    it 'on their dashboard and santa wishlist' do
      sign_in(o_1)
      visit dashboard_path
      click_on 'Create a Group'
      create_group(g_1)
      click_on 'Create Group'
      o_1.groups << g_1
      o_1.lists << l_1
      @users.each do |user|
        owner_invites_to_group(user, g_1)
      end
      @users.each do |user|
        accept_invitation(user)
      end
      sign_out_and_log_in(o_1)
      visit group_path(g_1.id)
      create_exclusion_teams(@teams)
      0.upto(4) do |num|
        add_to_exclusion_teams(@users[num], @teams[num % 2])
      end
      click_on 'Assign Secret Santas'
      expect(page).to have_content 'Santa Assignments Complete!'

      all_users_add_santa_message(@users, g_1)
      all_users_dashboard_wishlist_santa_message(@users, g_1)
    end
  end
end
