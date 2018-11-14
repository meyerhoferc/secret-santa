require 'rails_helper'

describe 'creating an invitation' do
  let(:group) { Group.create(name: 'Gift giving', description: 'We love gifts', gift_due_date: '2019-01-01') }
  let(:group_two) { Group.create(name: 'Thanks Gifting', description: 'We love gifts', gift_due_date: '2019-01-01') }
  let(:owner) { User.create(first_name: 'Ray', last_name: 'Lee', username: 'leeray', email: 'email@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:invitee) { User.create!(first_name: 'Lee', last_name: 'Ray', username: 'raylee', email: 'lee@ray.com', password: 'pas1203489y132809h132809hss1203489y132spa1203489y809h') }

  context 'as a group owner' do
    it 'inviting from user profile' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'

      visit user_path(invitee.id)
      page.select group.name, from: 'invitation[group_id]'
      fill_in 'invitation[comment]', with: 'Would you like to join?'
      click_on 'Submit'

      expect(page).to have_content 'Invitation sent'
      expect(page).to have_no_content 'Submit'
    end

    context 'inviting many groups' do
      it 'from user profile' do
        sign_in(owner)
        click_on 'Create a Group'
        create_group(group)
        click_on 'Create Group'
        visit dashboard_path
        click_on 'Create a Group'
        create_group(group_two)
        click_on 'Create Group'

        visit user_path(invitee.id)
        page.select group.name, from: 'invitation[group_id]'
        fill_in 'invitation[comment]', with: 'Would you like to join?'
        click_on 'Submit'
        expect(page).to have_content 'Invitation sent'

        page.select group_two.name, from: 'invitation[group_id]'
        fill_in 'invitation[comment]', with: 'Would you like to join?????'
        click_on 'Submit'
        expect(page).to have_content 'Invitation sent'
      end

      context 'attempting the same groups' do
        it 'multiple times' do
          sign_in(owner)
          click_on 'Create a Group'
          create_group(group)
          click_on 'Create Group'
          visit dashboard_path
          click_on 'Create a Group'
          create_group(group_two)
          click_on 'Create Group'

          visit user_path(invitee.id)
          page.select group.name, from: 'invitation[group_id]'
          fill_in 'invitation[comment]', with: 'Would you like to join?'
          click_on 'Submit'
          expect(page).to have_content 'Invitation sent'

          page.select group_two.name, from: 'invitation[group_id]'
          fill_in 'invitation[comment]', with: 'Would you like to join?????'
          click_on 'Submit'
          expect(page).to have_content 'Invitation sent'

          visit dashboard_path
          page.all('a', exact_text: group.name, visible:true).last.click
          fill_in 'Username or email', with: invitee.email
          fill_in 'invitation[comment]', with: 'Would you like to join our great group???'
          click_on 'Submit'
          expect(page).to have_content 'Receiver has already been invited to this group'

          visit dashboard_path
          page.all('a', exact_text: group_two.name, visible:true).last.click
          fill_in 'Username or email', with: invitee.email
          fill_in 'invitation[comment]', with: 'you  join  group'
          click_on 'Submit'
          expect(page).to have_content 'Receiver has already been invited to this group'
        end

        # let(:group_three) { Group.create(name: 'Thanks Gifting!!', description: 'We love gifts', gift_due_date: '2019-01-01') }
        context 'with invitations' do
          it 'pending' do
            sign_in(owner)
            click_on 'Create a Group'
            create_group(group)
            click_on 'Create Group'
            visit dashboard_path
            click_on 'Create a Group'
            create_group(group_two)
            click_on 'Create Group'
            visit user_path(invitee.id)
            page.select group.name, from: 'invitation[group_id]'
            fill_in 'invitation[comment]', with: 'Would you like to join?'
            click_on 'Submit'
            expect(page).to have_content 'Invitation sent'
            sign_out

            sign_in(invitee)
            expect(page).to have_content "#{owner.first_name} #{owner.last_name} has invited you to join the group #{group.name}"
            sign_out

            sign_in(owner)
            visit user_path(invitee.id)
            page.has_no_select?('invitation_group_id', with_options: [group.name])
            page.has_select?('invitation_group_id', with_options: [group_two.name])
            expect(page).to have_content group_two.name
          end

          it 'accepted' do
            sign_in(owner)
            click_on 'Create a Group'
            create_group(group)
            click_on 'Create Group'
            visit dashboard_path
            click_on 'Create a Group'
            create_group(group_two)
            click_on 'Create Group'
            visit user_path(invitee.id)
            page.select group.name, from: 'invitation[group_id]'
            fill_in 'invitation[comment]', with: 'Would you like to join?'
            click_on 'Submit'
            expect(page).to have_content 'Invitation sent'
            sign_out

            sign_in(invitee)
            expect(page).to have_content "#{owner.first_name} #{owner.last_name} has invited you to join the group #{group.name}"
            click_on 'Accept'
            sign_out

            sign_in(owner)
            visit user_path(invitee.id)
            page.has_no_select?('invitation_group_id', with_options: [group.name])
            page.has_select?('invitation_group_id', with_options: [group_two.name])
          end

          it 'declined' do
            sign_in(owner)
            click_on 'Create a Group'
            create_group(group)
            click_on 'Create Group'
            visit dashboard_path
            click_on 'Create a Group'
            create_group(group_two)
            click_on 'Create Group'
            visit user_path(invitee.id)
            page.select group.name, from: 'invitation[group_id]'
            fill_in 'invitation[comment]', with: 'Would you like to join?'
            click_on 'Submit'
            expect(page).to have_content 'Invitation sent'
            sign_out

            sign_in(invitee)
            expect(page).to have_content "#{owner.first_name} #{owner.last_name} has invited you to join the group #{group.name}"
            click_on 'Decline'
            sign_out

            sign_in(owner)
            visit user_path(invitee.id)
            page.has_select?('invitation_group_id', with_options: [group.name, group_two.name])
          end
        end
      end
    end

    it 'inviting from group owner user profile' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'

      visit user_path(owner.id)
      expect(page).to have_no_content "Invite #{owner.first_name} #{owner.last_name} to a Group", 'Submit'
    end

    context 'with email' do
      it 'inviting from group page' do
        sign_in(owner)
        click_on 'Create a Group'
        create_group(group)
        click_on 'Create Group'

        fill_in 'Username or email', with: invitee.email
        fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
        click_on 'Submit'

        expect(page).to have_content 'Invitation sent'
      end

      it 'inviting self from group page' do
        sign_in(owner)
        click_on 'Create a Group'
        create_group(group)
        click_on 'Create Group'

        fill_in 'Username or email', with: owner.email
        fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
        click_on 'Submit'

        expect(page).to have_content "#{owner.first_name} #{owner.last_name}:"
        expect(page).to have_content "Sender cannot send yourself an invitation"
      end
    end

    context 'with username' do
      it 'inviting from group page' do
        sign_in(owner)
        click_on 'Create a Group'
        create_group(group)
        click_on 'Create Group'

        fill_in 'Username or email', with: invitee.username
        fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
        click_on 'Submit'

        expect(page).to have_content 'Invitation sent'
      end

      it 'inviting self from group page' do
        sign_in(owner)
        click_on 'Create a Group'
        create_group(group)
        click_on 'Create Group'

        fill_in 'Username or email', with: owner.username
        fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
        click_on 'Submit'

        expect(page).to have_content "#{owner.first_name} #{owner.last_name}:"
        expect(page).to have_content "Sender cannot send yourself an invitation"
      end

      it 'incorrect username' do
        sign_in(owner)
        click_on 'Create a Group'
        create_group(group)
        click_on 'Create Group'

        fill_in 'Username or email', with: invitee.username + 'whis'
        fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
        click_on 'Submit'

        expect(page).to have_content "Please enter a username or email"
      end
    end

    it 'inviting with a blank comment' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'

      fill_in 'email', with: owner.email
      click_on 'Submit'

      expect(page).to have_content "Comment can't be blank and Sender cannot send yourself an invitation"
    end

    it 'inviting with a blank email' do
      sign_in(owner)
      click_on 'Create a Group'
      create_group(group)
      click_on 'Create Group'

      fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
      click_on 'Submit'

      expect(page).to have_content "Username or email can't be blank"
    end
  end

  let(:group) { Group.create(name: 'Gift giving', description: 'We love gifts', gift_due_date: '2019-01-01') }
  let(:owner) { User.create(first_name: 'Ray', last_name: 'Lee', username: 'leeray', email: 'email@ray.lee', password: 'hspa1203489y132809hss12034pas1203489y13280989y132809h') }
  let(:invitee) { User.create!(first_name: 'Lee', last_name: 'Ray', username: 'raylee', email: 'lee@ray.com', password: 'pas1203489y132809h132809hss1203489y132spa1203489y809h') }

  context 'not as a group owner' do
    it 'from user profile' do
      sign_in(invitee)

      visit user_path(owner.id)
      expect(page).to have_no_content "Invite #{owner.first_name} #{owner.last_name} to a Group", 'Submit'
    end

    context 'from group page' do
      it 'with email' do
        sign_in(owner)
        click_on 'Create a Group'
        create_group(group)
        click_on 'Create Group'
        fill_in 'email', with: invitee.email
        fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
        click_on 'Submit'
        expect(page).to have_content 'Invitation sent'
        sign_out

        sign_in(invitee)
        click_on 'Accept'
        page.all('a', exact_text: group.name, visible:true).last.click
        expect(page).to have_no_content 'Send an invitation', 'Submit'
      end

      it 'with username' do
       sign_in(owner)
       click_on 'Create a Group'
       create_group(group)
       click_on 'Create Group'
       fill_in 'email', with: invitee.username
       fill_in 'invitation[comment]', with: 'Would you like to join our great group?'
       click_on 'Submit'
       expect(page).to have_content 'Invitation sent'
       sign_out

       sign_in(invitee)
       click_on 'Accept'
       page.all('a', exact_text: group.name, visible:true).last.click
       expect(page).to have_no_content 'Send an invitation', 'Submit'
     end
    end
  end
end
