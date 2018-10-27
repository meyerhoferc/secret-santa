require 'rails_helper'

describe 'deleting' do
  let(:user) { User.create(first_name: 'Raaa', last_name: 'Zzzz', username: 'ZzzRaa', email: 'emmaiil@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
  let(:group) { Group.create(name: 'The best group there is, that I know', description: 'Whoever wants to join', gift_due_date: '2019/12/31') }
  let(:item_one) { Item.create(name: 'Keys', description: 'So many', size: 'S', note: 'I have many of these.') }

  it 'an item' do
    sign_in(user)
    click_on 'Create a Group'
    create_group(group)
    click_on 'Create Group'
    visit dashboard_path
    click_on group.name
    click_on 'View your Wish List'
    click_on 'Create a new Wish list item'
    create_item(item_one)
    click_on 'Create Item'

    expect(page).to have_link item_one.name
    click_on item_one.name
    click_on 'Delete Item'

    expect(page).to have_content "Item, #{item_one.name}, Deleted!"
    expect(page).to have_no_content item_one.description
    expect(page).to have_no_content item_one.size
    expect(page).to have_no_content item_one.note
  end
end
