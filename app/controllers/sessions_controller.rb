class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: login_credential) || User.find_by(email: login_credential)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:warning] = 'Username, Email or password invalid.'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Log out successful."
    redirect_to root_path
  end

  private

  def login_credential
    params[:username_email].downcase
  end
end
