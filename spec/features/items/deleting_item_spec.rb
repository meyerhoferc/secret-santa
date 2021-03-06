require 'rails_helper'

describe 'deleting' do
  let(:user) { User.create(first_name: 'Raaa', last_name: 'Zzzz', username: 'ZzzRaa', email: 'emmaiil@raa.zzz', password: 'pa1203489y132809hsspas1203489y132809hs') }
  let(:group) { Group.create(name: 'The best group there is, that I know', description: 'Whoever wants to join', gift_due_date: '2019/12/31') }
  let(:item_one) { Item.create(name: 'Keys', description: 'So many', size: 'Small', note: 'I have many of these.') }

  it 'an item' do
    sign_in(user)
    click_on 'Create a Group'
    create_group(group)
    click_on 'Create Group'
    visit dashboard_path
    page.all('a', exact_text: group.name, visible:true).last.click
    click_on 'My Wish List'
    create_item(item_one)
    click_on 'Create Item'

    expect(page).to have_link item_one.name
    click_on item_one.name
    click_on 'Delete Item'

    expect(page).to have_content "#{item_one.name}, deleted!"
    expect(page).to have_no_content item_one.description
    expect(page).to have_no_content item_one.size
    expect(page).to have_no_content item_one.note
  end
end
