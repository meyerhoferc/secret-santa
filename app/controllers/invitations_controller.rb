class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender_id = current_user.id
    @invitation.receiver_id = params[:user_id]
    @invitation.accepted = false
    # byebug
    @invitation.save
    redirect_to user_path(@invitation.receiver_id)
  end

  private

  def invitation_params
    params.require(:invitation).permit(:comment, :group_id)
  end
end
