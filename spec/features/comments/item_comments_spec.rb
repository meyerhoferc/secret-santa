require 'rails_helper'
include ActionView::Helpers::DateHelper

describe 'item comments' do
  let(:group) { Group.create(name: 'Gift giving', description: 'We love gifts', gift_due_date: (Time.current + 3.weeks).strftime("%Y-%m-%d")) }
  let(:owner) { User.create(first_name: 'Ray', last_name: 'Lee', username: 'leeray', email: 'email@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:invitee) { User.create!(first_name: 'Lee', last_name: 'Ray', username: 'raylee', email: 'lee@ray.com', password: 'pas1203489y132809h132809hss1203489y132spa1203489y809h') }
  let(:uninvited) { User.create!(first_name: 'Leer', last_name: 'Rayl', username: 'raylleee', email: 'rlee@rayl.com', password: 'pas1203489y132809h132809hss1dd203489y132spa1203489y809h') }
  let(:item_one) { Item.create(name: 'Wallet', description: 'So pretty', size: 'XL', note: 'I would like many of these.') }
  let(:comment_one) { Comment.new(text: 'This is my comment text')}
  let(:comment_two) { Comment.new(text: 'Other message by other user')}

  it 'created by group members' do
    sign_in(owner)
    click_on 'Create a Group'
    create_group(group)
    click_on 'Create Group'
    visit user_path(invitee.id)
    page.select group.name, from: 'invitation[group_id]'
    fill_in 'invitation[comment]', with: 'Would you like to join?'
    click_on 'Submit'
    visit dashboard_path
    page.all('a', exact_text: group.name).last.click
    page.all('a', exact_text: 'My Wish List').last.click
    create_item(item_one)
    click_on 'Create Item'
    click_on item_one.name

    fill_in 'comment[text]', with: comment_one.text
    click_on 'Submit comment'
    expect(page).to have_content comment_one.text
    expect(page).to have_content time_ago_in_words(Comment.where(text: comment_one.text).take.created_at, include_seconds: true)
    sign_out

    visit root_path
    sign_in(invitee)
    expect(current_path).to eq dashboard_path
    click_on 'Accept'
    page.all('a', exact_text: group.name, visible: true).last.click
    page.all('a', exact_text: 'Wish List').first.click
    click_on item_one.name

    fill_in 'comment[text]', with: comment_two.text
    click_on 'Submit comment'

    comment_one_saved = Comment.where(text: comment_one.text).take
    expect(page).to have_content comment_one.text
    expect(page).to have_content time_ago_in_words(comment_one_saved.created_at, include_seconds: true)
    comment_two_saved = Comment.where(text: comment_two.text).take
    expect(page).to have_content comment_two.text
    expect(page).to have_content time_ago_in_words(comment_two_saved.created_at, include_seconds: true)
    expect(page).to have_no_selector(:css, "a[href=\"#{url_for(controller: 'comments', action: 'destroy', only_path: true, id: comment_one_saved.id)}\"]")
    expect(page).to have_selector(:css, "a[href=\"#{url_for(controller: 'comments', action: 'destroy', only_path: true, id: comment_two_saved.id)}\"]")


    sign_out
    sign_in(owner)
    page.all('a', exact_text: group.name).last.click
    page.all('a', exact_text: 'Wish List').first.click
    click_on item_one.name
    comment_one_saved = Comment.where(text: comment_one.text).take
    expect(page).to have_content comment_one.text
    expect(page).to have_content time_ago_in_words(comment_one_saved.created_at, include_seconds: true)

    comment_two_saved = Comment.where(text: comment_two.text).take
    expect(page).to have_content comment_two.text
    expect(page).to have_content time_ago_in_words(comment_two_saved.created_at, include_seconds: true)
    expect(page).to have_selector(:css, "a[href=\"#{url_for(controller: 'comments', action: 'destroy', only_path: true, id: comment_one_saved.id)}\"]")
    expect(page).to have_selector(:css, "a[href=\"#{url_for(controller: 'comments', action: 'destroy', only_path: true, id: comment_two_saved.id)}\"]")
  end
end
