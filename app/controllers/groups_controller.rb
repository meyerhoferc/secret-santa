class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user_ids= current_user.id
    if @group.save
      redirect_to dashboard_path
    else
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
    # user_id_array = @group.user_ids
    # @users = user_id_array.map { |id| User.find(id) }
    # @users = @group.users
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update(group_params)
    flash.notice = "Group '#{@group.name}' updated!"
    redirect_to group_path(@group)
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash.notice = "Group Deleted!"
    redirect_to dashboard_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
