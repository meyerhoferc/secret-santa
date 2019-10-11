class RescueMailer < ApplicationMailer
  def rake_task_rescue(task, error)
    @task = task
    @error = error
    mail(to: "#{Rails.application.credentials.admin_email}", subject: "Task #{task} has encountered an exception")
  end
end
