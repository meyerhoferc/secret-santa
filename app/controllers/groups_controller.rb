class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action -> { unauthorized_user(@group.owner) }, only: [:update, :edit, :destroy]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user_ids << current_user.id # Add user as a user
    @group.owner_id = current_user.id # Add user as owner
    if authorized_user(@group.owner) && @group.save
      current_user.groups << @group
      create_list
      flash[:notice] = 'Group created successfully.'
      redirect_to group_path(@group)
    else
      flash[:warning] = full_sentence_errors(@group)
      render 'new'
    end
  end

  def show
    @user_wish_list = @group.user_wish_list(current_user)
    if authorized_user(@group.owner)
      @invitation = Invitation.new
      @exclusion_team = ExclusionTeam.new
      @exclusion_teams = @group.exclusion_teams.reorder('name ASC')
      @user_exclusion_team = UserExclusionTeam.new
      @santa_assignment = SantaAssignment.new
    end

    if current_user.belongs_to_group?(@group.id)
      @comments = Comment.where(commentable: @group).includes(:user).order(:created_at)
      @comment = Comment.new(user_id: current_user.id, commentable: @group)
    end

    if @group.santas_assigned
      @santa = User.find(current_user.secret_santa.find_by(group_id: @group.id).receiver_id)
    end
  end

  def edit
  end

  def update
    if authorized_user(@group.owner) && @group.update(group_params)
      flash[:notice] = "Group '#{@group.name}' updated!"
      redirect_to group_path(@group)
    else
      flash[:warning] = full_sentence_errors(@group)
      redirect_to edit_group_path(@group)
    end
  end

  def destroy
    lists = List.where(group_id: @group.id)
    if !lists.empty?
      lists.each do |list|
        items = Item.where(list_id: list.id)
        items.each { |item| item.destroy }
        list.destroy
      end
    end

    invitations = Invitation.where(group_id: @group.id)
    if !invitations.empty?
      invitations.each do |invitation|
        invitation.destroy
      end
    end

    santa_assignments = SantaAssignment.where(group_id: @group.id)
    if !santa_assignments.empty?
      santa_assignments.each do |assignment|
        assignment.destroy
      end
    end

    exclusion_teams = ExclusionTeam.where(group_id: @group.id)
    if exclusion_teams.present?
      exclusion_teams.each do |exclusion_team|
        if exclusion_team.user_exclusion_teams.present?
          exclusion_team.user_exclusion_teams.each do |user_exclusion_team|
            user_exclusion_team.destroy
          end
        end
        exclusion_team.destroy
      end
    end

    flash[:notice] = "Group #{@group.name} deleted!"
    @group.destroy
    redirect_to dashboard_path
  end

  private

  def create_list
    @list = List.new
    @list.user_id = current_user.id
    @list.group_id = @group.id
    @list.save
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :owner_id, :gift_due_date, :dollar_limit)
  end

  def belonging_user(user_list)
    user_list.any? do |user|
      user.user_id == current_user.id
    end
  end
end
