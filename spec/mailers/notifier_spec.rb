require "rails_helper"

include ActiveJob::TestHelper

RSpec.describe NotifierMailer, type: :mailer do
  describe 'welcome' do
    let(:user) { User.create(first_name: 'Joey', last_name: 'Ralf', username: 'jrsdflff', email: 'joey@ralf.com', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs') }
    subject(:mailer) { described_class.with(user: user).welcome }
    it { expect(mailer.subject).to eq 'Welcome to Secret Santa' }
    it { expect(mailer.to).to include user.email }
  end

  describe 'gift_due_date' do
    let(:days) { 14 }
    let(:user) { User.create(first_name: 'Joey', last_name: 'Ralfff', username: 'jrsdfasdflff', email: 'joasdfey@ralfdsaf.com', password: 'p1203489y132809has1203489y132809hs', password_confirmation: 'p1203489y132809has1203489y132809hs') }
    let(:group) { Group.create(name: 'test', gift_due_date: (Time.current + days.days)) }
    subject(:mailer_two) { described_class.with(user: user, group: group).gift_due_date(days) }
    it { expect(mailer_two.subject).to eq "In #{days} days your Secret Santa gift is due" }
    it { expect(mailer_two.to).to include user.email }
  end
end
