class ApplicationController < ActionController::API
  include ApplicationHelper
  helper_method :current_user, :authorized_user, :unauthorized_user, :svg
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
    if !logged_in?
      flash[:warning] = 'You need to be logged in first.'
      # redirect_to root_path
    end
  end

  def unauthorized_user(user)
    if !authorized_user(user)
      flash[:warning] = 'Action is unauthorized.'
      # redirect_to root_path
    end
  end

  def svg(name)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    return File.read(file_path).html_safe if File.exists?(file_path)
    '(not found)'
  end
end
