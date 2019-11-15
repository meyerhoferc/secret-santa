class NotifierMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    email_with_name = %("#{@user.full_name}" <#{@user.email}>)
    @login_url = { controller: 'sessions', action: 'new' }
    mail(to: email_with_name, subject: 'Welcome to Secret Santa')
  end

  def gift_due_date(days)
    @user = params[:user]
    @group = params[:group]
    @days = days
    email_with_name = %("#{@user.full_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: "You have #{@days.to_s} days until your Secret Santa gift exchange")
  end
end
