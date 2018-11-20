class ListsController < ApplicationController
  before_action :set_list, except: :index
  before_action :set_group, except: :index
  before_action :set_user, except: :index
  before_action -> { unauthorized_user(@user) }, except: [:show]

  def new
  end

  def create
    update_list_message('Message added.')
  end

  def show
    @items = @list.items
    @item = Item.new
  end

  def update
    update_list_message('Message updated.')
  end

  def destroy
    if authorized_user(@user)
      flash[:notice] = 'Message deleted.'
      @list.santa_message = nil
      @list.save
    else
      flash[:warning] = 'Action unauthorized.'
    end
    redirect_to group_list_path(@group, @list)
  end

  private

  def update_list_message(flash_message)
    if authorized_user(@user) && @list.update(list_params)
      flash[:notice] = flash_message
    else
      flash[:warning] = full_sentence_errors(@list)
    end
    redirect_to group_list_path(@group, @list)
  end

  def set_user
    @user = @list.user
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:santa_message)
  end
end
