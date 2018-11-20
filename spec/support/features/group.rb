module Features
  def create_group(group)
    fill_in('group_name', with: group.name)
    fill_in('group_description', with: group.description)
    fill_in('group_gift_due_date', with: group.gift_due_date.to_default_s)
  end

  def invite_to_group(user)
    fill_in('Username or email', with: user.email)
    fill_in('Message', with: 'Join now.')
    click_on 'Submit'
  end

  def owner_invites_to_group(user, group)
    visit group_path(group)
    invite_to_group(user)
    expect(page).to have_content 'Invitation sent'
  end
end
