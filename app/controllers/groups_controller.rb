class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all
  end
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user_ids = current_user.id # Add user as a user
    @group.owner_id = current_user.id # Add user as owner
    # CREATE THE WISHLIST HERE! SET IT AS THE OWNER'S LIST
    if @group.save
      redirect_to group_path(@group) # Find the group page
    else
      flash[:notice] = 'The group name is already taken. Please choose another name.'
      redirect_to new_group_path(@group)
    end
  end

  def show
    @user_list = @group.lists.where(['user_id = :user_id and group_id = :group_id',
                                    { user_id: current_user.id, group_id: @group.id }])
  end

  def edit
  end

  def update
    if @group.update(group_params)
      flash[:notice] = "Group '#{@group.name}' updated!"
      redirect_to group_path(@group)
    else
      flash[:warning] = 'An error occurred, please try again.'
      redirect_to edit_group_path(@group)
    end
  end

  def destroy
    # Destroy not working. Delete lists associated with group first.
    @group.destroy
    flash[:notice] = "Group Deleted!"
    redirect_to dashboard_path
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :owner_id)
  end
end
