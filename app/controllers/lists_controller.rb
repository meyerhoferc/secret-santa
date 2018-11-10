class ListsController < ApplicationController
  def show
    @list = List.find(params[:id])
    @user = @list.user
    @group = Group.find(params[:group_id])
    @items = @list.items
    @item = Item.new
  end
end
