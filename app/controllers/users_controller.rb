class UsersController < ApplicationController
  skip_before_action :root_path_if_not_logged_in, only: [:new, :create]
  before_action :set_user, only: [:edit, :update, :profile]
  before_action -> { unauthorized_user(User.find(params[:id])) }, only: [:update, :edit]

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
      flash[:warning] = @user.errors.full_messages.to_sentence
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
    @invitable_groups = @user.invitable_groups(current_user)
    @invitation = Invitation.new
  end

  def edit
  end

  def update
    segment_string = params[:commit].split(' ').last
    current_pass = params[:user][:current_password] || params[:current_password]
    @user.skip_pass_strength = true unless segment_string == 'Password'
    if authenticate_user(current_pass) && @user.update(validate_params(segment_string))
      flash[:notice] = "#{segment_string} successfully updated."
      redirect_to profile_path
    else
      flash[:warning] = @user.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  private

  def authenticate_user(current_pass)
    if @user.authenticate(current_pass)
      true
    else
      @user.errors.add(:password, 'is incorrect.')
      false
    end
  end

  def validate_params(string)
    case string
    when 'Name'
      return user_params
    when 'Email'
      downcase_email_param!
      return user_params
    when 'Password'
      return params.require(:user).permit(:password, :password_confirmation)
    end
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
