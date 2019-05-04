class Api::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, :root_path_if_not_logged_in

  def authenticate
    user = User.find_by(username: login_credential) || User.find_by(email: login_credential)
    if user && user.authenticate(params[:password])
      render json: authentication_payload(user)
    else
      render json: { errors: ['Invalid username or password'] }, status: :unauthorized
    end
  end

  private

  def authentication_payload(user)
    return nil unless user && user.id
    {
      auth_token: AuthToken.encode({user_id: user.id}),
      user: { id: user.id, username: user.username } # or other information
    }
  end

  def login_credential
    params[:username_email].downcase
  end
end
