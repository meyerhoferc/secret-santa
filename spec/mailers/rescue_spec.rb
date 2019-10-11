require "rails_helper"

include ActiveJob::TestHelper

RSpec.describe RescueMailer, type: :mailer do
  describe 'rake_task_rescue' do
    let(:task) { 'test_task' }
    let(:error) { tmp = StandardError.new('NoMethodError'); tmp.set_backtrace(['backtrace 1', 'backtrace 2', 'backtrace 3', 'backtrace 4', 'backtrace 5', 'backtrace 6', 'backtrace 7']); return tmp; }
    subject(:mailer) { described_class.rake_task_rescue(task, error.message, error.backtrace) }

    describe 'email contents' do
      it { expect(mailer.subject).to eq "#{task} has encountered an exception" }
      it { expect(mailer.to).to include "#{Rails.application.credentials.admin_email}" }
      it { expect(mailer.from).to include "#{Rails.application.credentials.smtp_user}" }
      it { expect(mailer.body.encoded).to match(task) }

      it 'displays error backtrace' do
        expect(mailer.body.encoded).to match(error.backtrace[0])
        expect(mailer.body.encoded).to match(error.backtrace[1])
        expect(mailer.body.encoded).to match(error.backtrace[2])
        expect(mailer.body.encoded).to match(error.backtrace[3])
        expect(mailer.body.encoded).to match(error.backtrace[4])
        expect(mailer.body.encoded).not_to match(error.backtrace[5])
        expect(mailer.body.encoded).not_to match(error.backtrace[6])
      end

      it 'email enqueue' do
        expect{ RescueMailer.rake_task_rescue(task, error.message, error.backtrace).deliver_later }
          .to have_enqueued_job.on_queue('mailers')
          .with('RescueMailer', 'rake_task_rescue', 'deliver_now', task, error.message, error.backtrace)
      end
    end
  end
end
