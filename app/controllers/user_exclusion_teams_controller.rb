class UserExclusionTeamsController < ApplicationController
  before_action :set_group, only: [:create, :destroy]
  before_action -> { unauthorized_user(@group.owner) }, only: [:create, :destroy]

  def create
    user_exclusion_team = UserExclusionTeam.new(user_exclusion_team_params)
    if user_exclusion_team.save
      flash[:notice] = "#{user_exclusion_team.user.full_name} added to #{user_exclusion_team.exclusion_team.name}."
    else
      flash[:warning] = user_exclusion_team.errors.full_messages.to_sentence
    end
    redirect_to group_path(@group)
  end

  def destroy
    team = UserExclusionTeam.where(user_id: params[:id], exclusion_team_id: params[:exclusion_team_id]).first
    flash[:notice] = "#{team.user.full_name} removed from #{team.exclusion_team.name}!"
    team.destroy
    redirect_to group_path(@group)
  end

  private

  def user_exclusion_team_params
    params.require(:user_exclusion_team).permit(:user_id, :exclusion_team_id)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
