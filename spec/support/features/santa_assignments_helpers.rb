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
end
