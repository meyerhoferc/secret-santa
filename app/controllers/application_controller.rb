class ApplicationController < ActionController::Base
  helper_method :current_user, :authorized_user
  before_action :root_path_if_not_logged_in

  def current_user
   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorized_user(other_user)
    current_user.id == other_user.id
  end

  def logged_in?
    current_user != nil
  end

  def root_path_if_not_logged_in
    flash[:warning] = 'You need to be logged in first.' unless logged_in?
    redirect_to root_path unless logged_in?
  end
end
