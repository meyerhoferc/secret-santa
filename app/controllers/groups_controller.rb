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
    @group.user_ids= current_user.id
    if @group.save
      redirect_to dashboard_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @group.update(group_params)
      flash[:notice] = "Group '#{@group.name}' updated!"
      redirect_to group_path(@group)
    else
      flash[:warning] = 'An error occurred, please try again.'
      render 'edit'
    end
  end

  def destroy
    @group.destroy
    flash[:notice] = 'Group Deleted!'
    redirect_to dashboard_path
  end

  private

  def set_group
   @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end
