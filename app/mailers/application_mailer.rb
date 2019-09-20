class ApplicationMailer < ActionMailer::Base
  default from: "#{Rails.application.credentials.smtp_user}@kcmr.io"
  layout 'mailer'
end
