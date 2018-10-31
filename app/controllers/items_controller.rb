class ItemsController < ApplicationController
  before_action :set_group
  before_action :set_list
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_user, except: :index
  before_action -> { unauthorized_user(@user) }, except: [:show]

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.list_id = @list.id
    if authorized_user(@user) && @item.save
      redirect_to group_list_path(@group, @list)
    else
      flash[:warning] = 'Please enter valid information.'
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if authorized_user(@user) && @item.update(item_params)
      flash[:notice] = "Item, #{@item.name}, updated."
      redirect_to group_list_item_path(@group, @list, @item)
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
end
