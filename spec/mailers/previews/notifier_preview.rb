# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
  def welcome
    NotifierMailer.with(user: User.first).welcome
  end

  def gift_due_date
    NotifierMailer.with(user: User.first, group: Group.first).gift_due_date(14)
  end
end
