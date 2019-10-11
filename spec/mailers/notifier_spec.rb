require "rails_helper"

include ActiveJob::TestHelper

RSpec.describe NotifierMailer, type: :mailer do
  describe 'welcome' do
    let(:user) { User.create(first_name: 'Joey', last_name: 'Ralf',
                 username: 'jrsdflff', email: 'joey@ralf.com',
                 password: 'p1203489y132809has1203489y132809hs',
                 password_confirmation: 'p1203489y132809has1203489y132809hs') }
    subject(:mailer) { described_class.with(user: user).welcome }
    describe 'email contents' do
      it { expect(mailer.subject).to eq 'Welcome to Secret Santa' }
      it { expect(mailer.to).to include user.email }
      it {expect(mailer.body.encoded).to match(user.full_name) }

    end

    it 'email enqueue' do
      expect{ NotifierMailer.with(user: user).welcome.deliver_later }
        .to have_enqueued_job.on_queue('mailers')
        .with('NotifierMailer', 'welcome', 'deliver_now', user: user)
    end
  end

  describe 'gift_due_date' do
    let(:days) { 14 }
    let(:user) { User.create(first_name: 'Joey', last_name: 'Ralfff',
                 username: 'jrsdfasdflff', email: 'joasdfey@ralfdsaf.com',
                 password: 'p1203489y132809has1203489y132809hs',
                 password_confirmation: 'p1203489y132809has1203489y132809hs') }
    let(:group) { Group.create(name: 'test',
                  gift_due_date: (Time.current + days.days),
                  owner: user,
                  description: 'test') }
    subject(:mailer_two) { described_class
                          .with(user: user, group: group)
                          .gift_due_date(days) }

    describe 'email contents' do
      it { expect(mailer_two.subject)
          .to eq "In #{days} days your Secret Santa gift is due" }
      it { expect(mailer_two.to).to include user.email }
      # it { expect(mailer_two.from).to include "#{Rails.application.credentials.smtp_user}" }
      describe 'in email body' do
        it 'has group name' do
          expect(mailer_two.body.encoded).to match(group.name)
        end
        it 'has user first name' do
          expect(mailer_two.body.encoded).to match(user.first_name)
        end
      end
    end

    it 'email enqueue' do
      expect{ NotifierMailer.with(user: user, group: group).gift_due_date(days).deliver_later }
        .to have_enqueued_job.on_queue('mailers')
        .with('NotifierMailer', 'gift_due_date', 'deliver_now', {user: user, group: group}, days)
    end
  end
end
