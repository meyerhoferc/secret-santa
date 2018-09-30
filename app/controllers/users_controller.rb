class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  
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
    if params[:id] && current_user
      @own_profile = own_profile?(current_user, params[:id])
      @user = User.find(params[:id])
    elsif current_user
      @own_profile = true
      set_user
    else
      redirect_to root_url
      flash[:warning] = 'You must be logged in first.'
    end
  end

  def edit
  end

  def update
    segment_string = params[:commit].split(' ')[1]
    if @user.update(validate_params(segment_string))
      flash[:notice] = "#{segment_string} successfully updated."
      redirect_to profile_path
    else
      flash[:warning] = "An error occurred, please try again."
      render 'edit'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def validate_params(string)
    case string
    when 'Name'
      return params.require(:user).permit(:first_name, :last_name)
    when 'Email'
      return params.require(:user).permit(:email)
    when 'Password'
      return params.require(:user).permit(:password, :password_confirmation)
    end
  end

  def own_profile?(current_user, user_profile_id)
    current_user.id == user_profile_id.to_i
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
