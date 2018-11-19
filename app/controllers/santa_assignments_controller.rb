class SantaAssignmentsController < ApplicationController
  before_action :set_group, only: [:assign]
  before_action -> { unauthorized_user(@group.owner) }, only: [:assign]

  def assign
    santa = SantaAssignmentService.new(@group).assign
    if santa.validity
      flash[:notice] = santa.validity.to_s
    else
      # Add error formatter method, similar to other helper method
      flash[:warning] = santa.errors.join(', ').to_s
    end
    redirect_to group_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
