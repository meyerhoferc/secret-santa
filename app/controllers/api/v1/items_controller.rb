class Api::V1::ItemsController < ApplicationController
  before_action :set_group
  before_action :set_list
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_user, except: :index
  before_action -> { unauthorized_user(@user) }, except: [:show]

  def create
    @item = Item.new(item_params)
    @item.list_id = @list.id
    if authorized_user(@user) && @item.save
      flash[:notice] = 'Item created successfully.'
    else
      flash[:warning] = full_sentence_errors(@item)
    end
    redirect_to group_list_path(@group, @list)
  end

  def show
  end

  def edit
  end

  def update
    if authorized_user(@user) && @item.update(item_params)
      flash[:notice] = "#{@item.name}, updated."
      redirect_to group_list_item_path(@group, @list, @item)
    else
      flash[:warning] = full_sentence_errors(@item)
      render 'edit'
    end
  end

  def destroy
    flash.notice = "#{@item.name}, deleted!"
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
