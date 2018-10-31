class UsersController < ApplicationController
  skip_before_action :root_path_if_not_logged_in, only: [:new, :create]
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
    @user.email.downcase! if @user.email
    @user.username.downcase!
    if @user.save
      flash[:notice] = "Account successfully created."
      redirect_to login_path
    else
      flash[:warning] = "Please enter valid credentials."
      redirect_to signup_path
    end
  end

  def profile
    if @user
      render 'show'
    else
      redirect_to root_url
      flash[:warning] = 'You must be logged in first.'
    end
  end

  def show
    @user = User.find(params[:id])
    @user_invitable_groups = invitable_groups
    @group_invitations = !@user_invitable_groups.empty? && !authorized_user(@user)
    # Groups owned by the current user && it is not the current user's profile
    if @group_invitations
      @invitation = Invitation.new
    end
  end

  def edit
  end

  def update
    segment_string = params[:commit].split(' ')[1]
    current_pass = params[:current_password] || params[:user][:password]
    if authenticate_user(current_pass) && @user.update(validate_params(segment_string))
      flash[:notice] = "#{segment_string} successfully updated."
      redirect_to profile_path
    else
      flash[:warning] = "An error occurred, please try again."
      render 'edit'
    end
  end

  private

  def authenticate_user(current_pass)
    !!@user.authenticate(current_pass)
  end

  def validate_params(string)
    case string
    when 'Name'
      return params.require(:user).permit(:first_name, :last_name, :password)
    when 'Email'
      downcase_email_param!
      return params.require(:user).permit(:email, :password)
    when 'Password'
      return params.require(:user).permit(:password, :password_confirmation)
    end
  end

  def invitable_groups
    Group.where("owner_id = ?", current_user.id).select do |group|
      user_does_not_belong_to_group = !group.users.ids.include?(@user.id)
      no_pending_user_invitations = user_invitations("group_id = ? AND receiver_id = ? AND accepted IS NULL", group.id, @user.id)
      no_declined_user_invitations = user_invitations("group_id = ? AND receiver_id = ? AND accepted = false", group.id, @user.id)
      user_does_not_belong_to_group && no_pending_user_invitations && no_declined_user_invitations
    end
  end

  def user_invitations(accepted_string, group, user)
    Invitation.joins(:group).where([accepted_string, group, user,]).empty?
  end

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
  end

  def downcase_email_param!
    params[:user][:email].downcase!
  end
end
