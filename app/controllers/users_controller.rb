class UsersController < ApplicationController
  def new
    @user = User.new
    if current_user
      redirect_to dashboard_path
    else
      render 'new'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path
    else
      render 'new'
    end
  end

  def show
    if current_user
      @user = User.find(session[:user_id])
      render 'show'
    else
      redirect_to root_url
      flash[:warning] = 'You must be logged in first.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
