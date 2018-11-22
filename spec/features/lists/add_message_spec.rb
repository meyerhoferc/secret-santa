require 'rails_helper'

describe 'adding a lists santa message' do
  let(:owner1) { User.create!(first_name: 'OwnerOne', last_name: 'One', username: 'owner1', email: 'email1@own.er', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:group1) { Group.create!(name: 'This Is One long Test Setupp', description: 'Why did I do it this way?', gift_due_date: '2023-01-01', owner_id: owner1.id) }
  let(:list1) { List.create(group_id: group1.id, user_id: owner1.id) }

  context 'as wishlist owner' do
    it 'adds the message' do
      owner1.groups << group1
      owner1.lists << list1
      sign_in(owner1)
      page.all('a', exact_text: group1.name, visible:true).last.click
      click_on 'My Wish List'
      click_on 'Add a message'
      fill_in 'Santa message', with: 'Cheerio'
      click_on 'Add message'
      expect(page).to have_content 'Message added.'
      expect(page).to have_content 'Cheerio'
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
      expect(page).to have_no_link 'Add a message'
    end
  end
end
