class Api::V1::SantaAssignmentsController < ApplicationController
  before_action :set_group, only: [:assign]
  before_action -> { unauthorized_user(@group.owner) }, only: [:assign]

  def assign
    santa = SantaAssignmentService.new(@group).assign
    if santa.validity
      flash[:notice] = santa_assignment_messages(santa)
    else
      flash[:warning] = santa_assignment_errors(santa)
    end
    redirect_to group_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
