class SantaAssignmentsController < ApplicationController
  before_action :set_group, only: [:assign]
  before_action -> { unauthorized_user(@group.owner) }, only: [:assign]

  def assign
    byebug
    flash[:notice] = 'Nothing.'
    redirect_to group_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
