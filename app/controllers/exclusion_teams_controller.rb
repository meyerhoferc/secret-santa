class ExclusionTeamsController < ApplicationController
  before_action :set_group, only: [:create, :edit, :update, :destroy]
  before_action :set_exclusion_team, only: [:edit, :update, :destroy]
  before_action -> { unauthorized_user(@group.owner) }, only: [:create, :edit, :update, :destroy]

  def create
    team = ExclusionTeam.new(exclusion_team_params)
    team.group_id = @group.id
    if team.save
      flash[:notice] = "Exclusion team \"#{team.name}\" added."
    else
      # use new helper method!!!
      flash[:warning] = team.errors.full_messages.to_sentence
    end
    redirect_to group_path(@group)
  end

  def edit
  end

  def update
    if authorized_user(@group.owner) && @exclusion_team.update(exclusion_team_params)
      flash[:notice] = "Exclusion Team \"#{@exclusion_team.name}\" updated!"
    else
      #USE NEW HELPER METHOD WHEN PULLING IN
      flash[:warning] = @exclusion_team.errors.full_messages.to_sentence
    end
    redirect_to group_path(@group)
  end

  def destroy
    user_exclusion_teams = UserExclusionTeam.where(exclusion_team_id: @exclusion_team.id)

    if !user_exclusion_teams.empty?
      user_exclusion_teams.each do |team|
        team.destroy
      end
    end

    flash[:notice] = "Exclusion team \"#{@exclusion_team.name}\" deleted!"
    @exclusion_team.destroy
    redirect_to group_path(@group)
  end

  private

  def set_exclusion_team
    @exclusion_team = ExclusionTeam.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def exclusion_team_params
    params.require(:exclusion_team).permit(:name)
  end
end
