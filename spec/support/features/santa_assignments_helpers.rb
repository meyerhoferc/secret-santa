module Features
  def accept_invitation(user)
    sign_out_and_log_in(user)
    visit dashboard_path
    click_on 'Accept'
  end

  def add_to_exclusion_teams(user, team)
    page.select user.full_name, from: 'user_exclusion_team[user_id]'
    page.select team.name, from: 'user_exclusion_team[exclusion_team_id]'
    click_on 'Add to Team'
  end

  def create_exclusion_teams(teams)
    teams.each do |team|
      fill_in 'exclusion_team[name]', with: team.name
      click_on 'Add Exclusion Team'
    end
  end

  def pages_to_have_santa_name_all_users(users, group)
    users.each do |user|
      sign_out_and_log_in(user)
      visit group_path(group.id)
      expect(page).to have_content "#{user.secret_santa.find_by(group_id: group.id).recipient.full_name}"
      visit dashboard_path
      expect(page).to have_content "#{user.secret_santa.find_by(group_id: group.id).recipient.full_name}"
    end
  end

  def all_users_dashboard_wishlist_santa_message(users, group)
    users.each do |user|
      santa = user.secret_santa.find_by(group_id: group.id).recipient
      santa_wishlist = santa.lists.find_by(group_id: group.id)
      santa_message = santa_wishlist.santa_message
      sign_out_and_log_in(user)
      expect(page).to have_content "#{santa_message}", santa.full_name
      visit group_list_path(group.id, santa_wishlist.id)
      expect(page).to have_content "#{santa_message}", santa.full_name
      expect(page).to have_content "#{user.full_name}"
    end
  end

  def all_users_add_santa_message(users, group)
    users.each do |user|
      sign_out_and_log_in(user)
      page.all('a', exact_text: group.name, visible:true).last.click
      click_on 'My Wish List'
      click_on 'Add a message'
      fill_in 'Santa message', with: "Hi Santa! bring me coffee, thanks #{user.full_name}"
      click_on 'Add message'
      expect(page).to have_content 'Message added.'
      expect(page).to have_content "Hi Santa! bring me coffee, thanks #{user.full_name}"
    end
  end
end
