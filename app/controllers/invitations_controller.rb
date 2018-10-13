class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)
    # byebug
    @invitation.sender_id = current_user.id
    @invitation.receiver_id = params[:user_id]
    @invitation.save
    redirect_to user_path(@invitation.receiver_id)
  end

  def edit # Accept route
    # byebug
    @user = User.find(params[:user_id])
    @group = Group.find(Invitation.find(params[:id]).group_id)
    @invitation = Invitation.find(params[:id])
    @invitation.accepted = true
    @invitation.save
    @user.groups << @group
    create_list
    redirect_to dashboard_path
  end

  def destroy # Decline route
    @invitation = Invitation.find(params[:id])
    @invitation.accepted = false
    @invitation.save
    redirect_to dashboard_path
  end

  private

  def invitation_params
    params.require(:invitation).permit(:comment, :group_id)
  end

  def create_list
    @list = List.new
    @list.user_id = current_user.id
    @list.group_id = @group.id
    @list.save
  end
end
