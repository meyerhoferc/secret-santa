class ListsController < ApplicationController
  def show
    @list = List.find(params[:id])
    @user = @list.user
    @group = Group.find(params[:group_id])
    @items = @list.items
    @authorized_user = authorized_user(@user)
  end
end
