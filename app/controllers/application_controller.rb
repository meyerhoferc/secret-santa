class ApplicationController < ActionController::Base
  helper_method :current_user, :authorized_user

  def current_user
   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorized_user(other_user)
    current_user.id == other_user.id
  end
end
