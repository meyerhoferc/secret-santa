class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender_id = current_user.id
    @invitation.receiver_id = params[:user_id]
    @invitation.save
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
    redirect_to dashboard_path
  end

  def decline
    @invitation = Invitation.find(params[:id])
    @invitation.accepted = false
    @invitation.save
    redirect_to dashboard_path
  end

  def invite
    # sent from the groups page, by the group owner

    # params[:invitation][:receiver_id] is a string for an email
    # email = params[:invitation][:receiver_id].downcase
    receiver = User.find_by(email: downcase_email_param)
    group = Group.find(params[:group_id])
    if receiver
      no_pending_user_invitations = user_invitations("group_id = ? AND receiver_id = ? AND accepted IS NULL", group.id, receiver.id)
      no_declined_user_invitations = user_invitations("group_id = ? AND receiver_id = ? AND accepted = false", group.id, receiver.id)
      not_inviting_self = (group.owner_id != receiver.id)
    end

    if no_pending_user_invitations && no_declined_user_invitations && not_inviting_self
      invitation = Invitation.new
      invitation.group_id = group.id
      invitation.receiver_id = receiver.id
      invitation.sender_id = group.owner_id
      invitation.comment = params[:invitation][:comment]
      if invitation.save
        flash[:notice] = 'Invitation sent.'
      else
        flash[:warning] = 'There was an error sending the invitation, please try again.'
      end
    else
      flash[:notice] = "Invitation sent to user's email."
      # Default failure behavior to not give away user's email
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

  def downcase_email_param
    params[:invitation][:receiver_id].downcase
  end
end
