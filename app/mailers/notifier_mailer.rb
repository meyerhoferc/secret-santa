class NotifierMailer < ApplicationMailer
  default from: 'santa@kcmr.io'
  delivery_method :test
  def welcome(recipient)
    @account = recipient
    
  end
end
