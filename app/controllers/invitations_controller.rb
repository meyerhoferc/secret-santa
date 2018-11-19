class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender_id = current_user.id
    @invitation.receiver_id = params[:user_id]
    if @invitation.save
      flash[:notice] = 'Invitation sent'
      redirect_to user_path(@invitation.receiver_id)
    else
      flash[:warning] = full_sentence_errors(@invitation)
      redirect_to user_path(@invitation.receiver_id)
    end
  end

  def accept
    invitation = Invitation.find(params[:id])
    user = invitation.receiver
    if authorized_user(user)
      @group = Group.find(invitation.group_id)
      invitation.accepted = true
      invitation.save
      if !user.groups.include?(@group)
        user.groups << @group
        create_list
        flash[:notice] = 'Invitation accepted.'
        redirect_to dashboard_path
      else
        flash[:warning] = 'You already belong to this group.'
        redirect_to dashboard_path
      end
    else
      flash[:warning] = 'Action is unauthorized.'
      redirect_to root_path
    end
  end

  def decline
    invitation = Invitation.find(params[:id])
    user = invitation.receiver
    if authorized_user(user)
      invitation.accepted = false
      invitation.save
      flash[:notice] = 'Invitation declined.'
      redirect_to dashboard_path
    else
      flash[:warning] = 'Action is unauthorized.'
      redirect_to root_path
    end
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
        flash[:notice] = 'Invitation sent'
      else
        flash[:warning] = full_sentence_errors(invitation)
      end
    elsif params[:username_email].blank?
      flash[:warning] = "Username or email can't be blank"
    else
      flash[:notice] = "Please enter a username or email"
      # Create a new user with this email address, eventually sending them an invitation email.
    end
    redirect_to group_path(group.id)
  end

  private

  def invitation_params
    params.require(:invitation).permit(:comment, :group_id)
  end

  def create_list
    list = List.new
    list.user_id = current_user.id
    list.group_id = @group.id
    list.save
  end

  def login_credential
    params[:username_email].downcase
  end
end
