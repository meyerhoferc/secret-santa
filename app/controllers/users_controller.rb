class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def show
    if !session[:user_id]
      flash[:warning] = 'You must be logged in first.'
      redirect_to root_url
    else
      @user = User.find(session[:user_id])
      render 'show'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
