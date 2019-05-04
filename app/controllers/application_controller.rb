class AccessDeniedError < StandardError
end

class NotAuthenticatedError < StandardError
end

class AuthenticationTimeoutError < StandardError
end


class ApplicationController < ActionController::Base
  include ApplicationHelper
  attr_reader :current_api_user
  helper_method :current_user, :authorized_user, :unauthorized_user, :svg
  before_action :root_path_if_not_logged_in

  rescue_from AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from NotAuthenticatedError, with: :user_not_authenticated

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
      redirect_to root_path
    end
  end

  def unauthorized_user(user)
    if !authorized_user(user)
      flash[:warning] = 'Action is unauthorized.'
      redirect_to root_path
    end
  end

  def svg(name)
    file_path = "#{Rails.root}/app/assets/images/#{name}.svg"
    return File.read(file_path).html_safe if File.exists?(file_path)
    '(not found)'
  end

  def authenticate_api_request!
    fail NotAuthenticatedError unless user_id_included_in_auth_token?
    @current_api_user = User.find(decoded_auth_token[:user_id])
  rescue JWT::ExpiredSignature
    raise AuthenticationTimeoutError
  rescue JWT::VerificationError, JWT::DecodeError
    raise NotAuthenticatedError
  end

  private

  def user_id_included_in_auth_token?
    http_auth_token && decoded_auth_token && decoded_auth_token[:user_id]
  end

  def decoded_auth_token
    @decoded_auth_token ||= AuthToken.decode(http_auth_token)
  end

  def http_auth_token
    @http_auth_token ||= if request.headers['Authorization'].present?
                            request.headers['Authorization'].split(' ').last
                         end
  end

  def authentication_timeout
    render json: { errors: ['Authentication Timeout'] }, status: 419
  end

  def forbidden_resource
    render json: { errors: ['Not Authorized To Access Resource'] }, status: :forbidden
  end

  def user_not_authenticated
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end
end
