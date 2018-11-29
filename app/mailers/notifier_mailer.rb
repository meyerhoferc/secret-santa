class NotifierMailer < ApplicationMailer
  default from: 'santa@kcmr.io'
  
  def welcome
    @user = params[:user]
    email_with_name = %("#{@user.full_name}" <#{@user.email}>)
    @login_url = { controller: 'sessions', action: 'new' }
    mail(to: email_with_name, subject: 'Welcome to Secret Santa')
  end
end
