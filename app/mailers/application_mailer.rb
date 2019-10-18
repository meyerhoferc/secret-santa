class ApplicationMailer < ActionMailer::Base
  default from: "#{Rails.application.credentials.smtp_user}"
  layout 'mailer'
end
