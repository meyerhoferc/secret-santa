class RescueMailer < ApplicationMailer
  def rake_task_rescue(task, error_message, error_backtrace)
    @task = task
    @error_message = error_message
    @error_backtrace = error_backtrace
    mail(to: "#{Rails.application.credentials.admin_email}", subject: "#{task} has encountered an exception")
  end
end
