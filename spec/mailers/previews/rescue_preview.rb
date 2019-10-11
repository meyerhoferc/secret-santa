# Preview all emails at http://localhost:3000/rails/mailers/rescue
class RescuePreview < ActionMailer::Preview
  def rake_task_rescue
    error = StandardError.new('NoMethodError')
    error.set_backtrace(['backtrace 1', 'backtrace 2', 'backtrace 3', 'backtrace 4', 'backtrace 5', 'backtrace 6', 'backtrace 7'])
    RescueMailer.rake_task_rescue('test_task', error)
  end
end
