class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender_id = current_user.id
    @invitation.receiver_id = params[:user_id]
    @invitation.save
    flash[:notice] = 'Invitation sent.'
    redirect_to user_path(@invitation.receiver_id)
  end

  def accept
    @invitation = Invitation.find(params[:id])
    @user = User.find(@invitation.receiver_id)
    @group = Group.find(@invitation.group_id)
    @invitation.accepted = true
    @invitation.save
    @user.groups << @group
    create_list
    flash[:notice] = 'Invitation accepted.'
    redirect_to dashboard_path
  end

  def decline
    @invitation = Invitation.find(params[:id])
    @invitation.accepted = false
    @invitation.save
    flash[:notice] = 'Invitation declined.'
    redirect_to dashboard_path
  end

  def invite
    # sent from the groups page, by the group owner
    receiver = User.find_by(username: login_credential) || User.find_by(email: login_credential)
    group = Group.find(params[:group_id])
    if receiver
      invitation = Invitation.new
      invitation.group_id = group.id
      invitation.receiver_id = receiver.id
      invitation.sender_id = group.owner_id
      invitation.comment = params[:invitation][:comment]
      if invitation.save
        flash[:notice] = 'Invitation sent.'
      else
        flash[:warning] = invitation.errors.full_messages.to_sentence
      end
    elsif !params[:username_email].blank?
    else
      flash[:notice] = "Please enter a username or email."
      # Create a new user with this email address, eventually sending them an invitation email.
    end
    redirect_to group_path(group.id)
  end

  private

  def user_invitations(accepted_string, group, user)
    Invitation.joins(:group).where([accepted_string, group, user,]).empty?
  end

  def invitation_params
    params.require(:invitation).permit(:comment, :group_id)
  end

  def create_list
    @list = List.new
    @list.user_id = current_user.id
    @list.group_id = @group.id
    @list.save
  end

  def login_credential
    params[:username_email].downcase
  end
end
