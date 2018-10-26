module Features
  def create_group(group)
    fill_in('group_name', with: group.name)
    fill_in('group_description', with: group.description)
    fill_in('group_gift_due_date', with: group.gift_due_date.to_default_s)
  end
end
