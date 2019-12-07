class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:notice] = 'Comment added.'
    else
      flash[:warning] = 'Comment could not be saved.'
    end
    redirect_to redirect_path
  end

  def edit

  end

  def update

  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.deletable_by_user_id?(current_user.id)
      flash[:notice] = 'Comment deleted.'
      @comment.delete
    else
      flash[:warning] = 'You cannot delete this comment.'
    end
    redirect_to redirect_path
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :commentable_id, :commentable_type, :text)
  end

  def redirect_path
    if @comment.commentable_type == 'Group'
      @comment.commentable
    elsif @comment.commentable_type == 'List'
      group_list_path(@comment.commentable.group_id, @comment.commentable.id)
    elsif @comment.commentable_type == 'Item'
      group_list_item_path(@comment.commentable.list.group_id, @comment.commentable.list_id, @comment.commentable.id)
    end
  end
end
