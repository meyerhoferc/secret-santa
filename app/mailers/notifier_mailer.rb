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
    email_with_name = %("#{@user.full_name}" <#{@user.email}>)
    mail(to: email_with_name, subject: "In #{days.to_s} days your Secret Santa gift is due")
  end
end
