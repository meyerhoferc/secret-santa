# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
  def welcome
    NotifierMailer.with(user: User.first).welcome
  end
end
