require 'rails_helper'

describe 'assigning santas' do
  context 'in exclusion teams' do
    let(:o_1) { User.create!(first_name: 'OwnerOne', last_name: 'One', username: 'owner1', email: 'email1@own.er', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_1) { User.create!(first_name: 'RayOne', last_name: 'LeeOne', username: 'leeray1', email: 'email1@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_2) { User.create!(first_name: 'RayTwo', last_name: 'LeeTwo', username: 'leeray2', email: 'email2@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_3) { User.create!(first_name: 'RayThree', last_name: 'LeeThree', username: 'leeray3', email: 'email3@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_4) { User.create!(first_name: 'RayFour', last_name: 'LeeFour', username: 'leeray4', email: 'email4@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_5) { User.create!(first_name: 'RayFive', last_name: 'LeeFive', username: 'leeray5', email: 'email5@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_6) { User.create!(first_name: 'RaySix', last_name: 'LeeSix', username: 'leeray6', email: 'email6@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_7) { User.create!(first_name: 'RaySeven', last_name: 'LeeSeven', username: 'leeray7', email: 'email7@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_8) { User.create!(first_name: 'RayEight', last_name: 'LeeEight', username: 'leeray8', email: 'email8@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_9) { User.create!(first_name: 'RayNine', last_name: 'LeeNine', username: 'leeray9', email: 'email9@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_10) { User.create!(first_name: 'RayTen', last_name: 'LeeTen', username: 'leeray10', email: 'email10@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_11) { User.create!(first_name: 'RayEleven', last_name: 'LeeEleven', username: 'leeray11', email: 'email11@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_12) { User.create!(first_name: 'RayTwelve', last_name: 'LeeTwelve', username: 'leeray12', email: 'email12@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_13) { User.create!(first_name: 'RayThirteen', last_name: 'LeeThirteen', username: 'leeray13', email: 'email13@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_14) { User.create!(first_name: 'RayFourteen', last_name: 'LeeFourteen', username: 'leeray14', email: 'email14@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_15) { User.create!(first_name: 'RayFifteen', last_name: 'LeeFifteen', username: 'leeray15', email: 'email15@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_16) { User.create!(first_name: 'RaySixteen', last_name: 'LeeSixteen', username: 'leeray16', email: 'email16@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_17) { User.create!(first_name: 'RaySeventeen', last_name: 'LeeSeventeen', username: 'leeray17', email: 'email17@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_18) { User.create!(first_name: 'RayEighteen', last_name: 'LeeEighteen', username: 'leeray18', email: 'email18@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_19) { User.create!(first_name: 'RayNinteen', last_name: 'LeeNinteen', username: 'leeray19', email: 'email19@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:u_20) { User.create!(first_name: 'RayTwenty', last_name: 'LeeTwenty', username: 'leeray20', email: 'email20@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
    let(:g_1) { Group.create(name: 'This Is One long Test Setupp', description: 'Why did I do it this way?', gift_due_date: '2023-01-01', owner_id: o_1.id) }
    let(:g_2) { Group.create(name: 'This Is One long Test Setup I tell you', description: 'Why did I do it this way?', gift_due_date: '2023-01-01', owner_id: o_1.id) }
    let(:e_t_1) { ExclusionTeam.create(group_id: g_1.id, name: 'Team One!!') }
    let(:e_t_2) { ExclusionTeam.create(group_id: g_1.id, name: 'Team Two!!') }
    let(:e_t_3) { ExclusionTeam.create(group_id: g_1.id, name: 'Team Three!!') }
    let(:e_t_4) { ExclusionTeam.create(group_id: g_1.id, name: 'Team Four!!') }
    let(:e_t_5) { ExclusionTeam.create(group_id: g_1.id, name: 'Team Five!!') }
    let(:l_1) { List.create(group_id: g_1.id, user_id: o_1.id) }
    let(:l_2) { List.create(group_id: g_2.id, user_id: o_1.id) }

    before { @users = [u_1, u_2, u_3, u_4, u_5, u_6, u_7, u_8, u_9, u_10, u_11, u_12, u_13, u_14, u_15, u_16, u_17, u_18, u_19, u_20] }
    before { @teams = [e_t_1, e_t_2, e_t_3, e_t_4, e_t_5] }

    it 'displays recipient\'s name on dashboard and group' do
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
      0.upto(10) do |num|
        add_to_exclusion_teams(@users[num], @teams[num % 5])
      end

      click_on 'Assign Secret Santas'
      expect(page).to have_content 'Santa Assignments Complete!'
      pages_to_have_santa_name_all_users(@users, g_1)
    end

    it 'puts half + 1 users in one exclusion team, displays error' do
      sign_in(o_1)
      visit dashboard_path
      click_on 'Create a Group'
      create_group(g_2)
      click_on 'Create Group'
      o_1.groups << g_2
      o_1.lists << l_2
      @users.each do |user|
        owner_invites_to_group(user, g_2)
      end
      @users.each do |user|
        accept_invitation(user)
      end
      sign_out_and_log_in(o_1)
      visit group_path(g_2.id)
      create_exclusion_teams(@teams)
      0.upto(10) do |num|
        add_to_exclusion_teams(@users[num], @teams[0])
      end
      11.upto(19) do |num|
        add_to_exclusion_teams(@users[num], @teams[rand(1..4)])
      end

      click_on 'Assign Secret Santas'
      expect(page).to have_content '"Team One!!" has too many users'
    end

    it 'displays/hides content after assigning santas' do
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
      0.upto(19) do |num|
        add_to_exclusion_teams(@users[num], @teams[num % 5])
      end

      click_on 'Assign Secret Santas'
      expect(page).to have_content 'Santa Assignments Complete!'
      expect(page).to have_no_content 'Send an invitation'
      expect(page).to have_no_content 'Assign Secret Santas'

      click_on "#{o_1.secret_santa.find_by(group_id: g_1.id).recipient.full_name}'s Wish List"
      expect(page).to have_content "Private Message to #{o_1.full_name}"
    end

    it 'displays/hides content after assigning santas without exclusion teams' do
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

      click_on 'Assign Secret Santas'
      expect(page).to have_content 'Santa Assignments Complete!'
      expect(page).to have_no_content 'Send an invitation'
      expect(page).to have_no_content 'Assign Secret Santas'

      click_on "#{o_1.secret_santa.find_by(group_id: g_1.id).recipient.full_name}'s Wish List"
      expect(page).to have_content "Private Message to #{o_1.full_name}"
      pages_to_have_santa_name_all_users(@users, g_1)
    end
  end
end
