class ListsController < ApplicationController
  def create
    @list = List.new
    @list.user_id = current_user.id
    @list.group_id = params[:group_id]
    @list.save
    redirect_to group_path(params[:group_id])
  end

  def show
    @list = List.find(params[:id])
    @user = @list.user
    @group = Group.find(params[:group_id])
    @items = Item.where(['lists_id = :list_id', { list_id: @list.id }])
  end
end
