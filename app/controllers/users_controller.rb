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
    @user.email.downcase!
    if @user.save
      redirect_to login_path
    else
      flash[:warning] = "Please enter valid credentials."
      redirect_to signup_path
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
    @user_invitable_groups = invitable_groups
    @group_invitations = !@user_invitable_groups.empty? && !@authorized_user
    # Groups owned by the current user && it is not the current user's profile
    if @group_invitations
      @invitation = Invitation.new
    end
  end

  def edit
  end

  def update
    segment_string = params[:commit].split(' ')[1]
    if password_change(segment_string) && @user.update(user_params)
      flash[:notice] = 'Password successfully updated.'
      redirect_to profile_path
    elsif @user.update(user_params)
      flash[:notice] = "#{segment_string} successfully updated."
      redirect_to profile_path
    else
      flash[:warning] = "An error occurred, please try again."
      render 'edit'
    end
  end

  private

  def password_change(string)
    string == 'Password' && @user.authenticate(params[:current_password])
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
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end

  def downcase_email_param!
    params[:user][:email].downcase!
  end
end
