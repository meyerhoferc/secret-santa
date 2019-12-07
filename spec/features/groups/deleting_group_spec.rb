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

  context 'with exclusion teams' do
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
      page.all('a', exact_text: g_1.name, visible:true).last.click

      click_on 'Delete'
      expect(page).to have_content "Group #{g_1.name} deleted!"
    end
  end
end
