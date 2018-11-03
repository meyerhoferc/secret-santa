class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action -> { unauthorized_user(@group.owner) }, only: [:update, :edit, :destroy]

  def index # Delete for the future?
    @groups = Group.all
  end

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
      flash[:notice] = 'The group name is already taken. Please choose another name.'
      render 'new'
    end
  end

  def show
    @user_wish_list = @group.user_wish_list(current_user)
    if authorized_user(@group.owner)
      @invitation = Invitation.new
    end
  end

  def edit
  end

  def update
    if authorized_user(@group.owner) && @group.update(group_params)
      flash[:notice] = "Group '#{@group.name}' updated!"
      redirect_to group_path(@group)
    else
      flash[:warning] = 'Please enter valid information.'
      redirect_to edit_group_path(@group)
    end
  end

  def destroy
    @lists = List.where("group_id = :group_id", {group_id: @group.id})
    if !@lists.empty?
      @lists.each do |list|
        items = Item.where("lists_id = :list_id", {list_id: list.id})
        items.each { |item| item.destroy }
        list.destroy
      end
    end

    @invitations = Invitation.where("group_id = :group_id", {group_id: @group.id})
    if !@invitations.empty?
      @invitations.each do |invitation|
        invitation.destroy
      end
    end

    @group.destroy
    flash[:notice] = "Group Deleted!"
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
    params.require(:group).permit(:name, :description, :owner_id, :gift_due_date)
  end

  def belonging_user(user_list)
    user_list.any? do |user|
      user.user_id == current_user.id
    end
  end
end
