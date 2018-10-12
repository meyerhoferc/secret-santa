class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :profile]

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

  def profile
    if @user
      @authorized_user = true
      render 'show'
    else
      redirect_to root_url
      flash[:warning] = 'You must be logged in first.'
    end
  end

  def show
    @user = User.find(params[:id])
    @authorized_user = authorized_user(@user)
    if @invitable = invitable?(current_user, @user)
      @invitation = Invitation.new
      @current_user_owned_groups = Group.where("owner_id = ?", current_user.id)
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


  def invitable?(logged_in_user, user_profile)

    # Group.joins(:users).where(id: [25, 28]).where(users: { id: 12 })

    # byebug
    if logged_in_user == user_profile
      return false
    elsif !Group.joins(:users).where(id: user_profile.groups.ids).where(users: {id: logged_in_user.id}).empty?
      return false
    end
    return true
  end

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

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
