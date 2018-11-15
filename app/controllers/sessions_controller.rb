class SessionsController < ApplicationController
  skip_before_action :root_path_if_not_logged_in, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: downcase_email)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:warning] = 'Email or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Log out successful."
    redirect_to root_path
  end

  private

  def downcase_email
    params[:email].downcase
  end
end
