class ItemsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @list = List.find(params[:list_id])
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @list = List.find(params[:list_id])
    @group = Group.find(params[:group_id])
    @user = @list.user
    @item.lists_id = @list.id
    if @item.save
      redirect_to group_list_path(@group, @list)
    else
      flash[:warning] = 'Invalid entry.'
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @group = Group.find(params[:group_id])
    @list = @user.lists
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :note, :size)
  end
end
