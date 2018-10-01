class ItemsController < ApplicationController
  before_action :set_group, only: [:new, :create, :show, :edit, :destroy]
  before_action :set_list, only: [:new, :create, :show, :edit, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:create, :show] # check if needed in `show`

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.lists_id = @list.id
    if @item.save
      redirect_to group_list_path(@group, @list)
    else
      flash[:warning] = 'Invalid entry.'
      render 'new'
    end
  end

  def show
    @item_owner = item_owner?(current_user, @user)
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to group_list_item_path(@item)
      flash[:notice] = "Item, #{@item.name}, updated."
    else
      flash[:warning] = 'An error occurred, please try again.'
      render 'edit'
    end
  end

  def destroy
    flash.notice = "Item, #{@item.name}, Deleted!"
    @item.destroy
    redirect_to group_list_path(@group, @list)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_user
    @user = @list.user
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_list
    @list = List.find(params[:list_id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :note, :size)
  end

  def item_owner?(current_user, user)
    current_user.id == user.id
  end
end
