class CommentsController < ApplicationController

  def create
    comment = Comment.new(comment_params)
    if comment.save
      flash[:notice] = 'Comment added.'
    else
      flash[:warning] = 'Comment could not be saved.'
    end
    if comment.commentable_type == 'Group'
      redirect_to comment.commentable
    elsif comment.commentable_type == 'List'
      redirect_to group_list_path(comment.commentable.group_id, comment.commentable.id)
    elsif comment.commentable_type == 'Item'
      redirect_to group_list_item_path(comment.commentable.list.group_id, comment.commentable.list_id, comment.commentable.id)
    end
  end

  def edit

  end

  def update

  end

  def destroy
    comment = Comment.find(params[:id])
    if current_user.id == comment.user_id
      flash[:notice] = 'Comment deleted.'
      comment.delete
    else
      flash[:warning] = 'You cannot delete this comment.'
    end
    if comment.commentable_type == 'Group'
      redirect_to comment.commentable
    elsif comment.commentable_type == 'List'
      redirect_to group_list_path(comment.commentable.group_id, comment.commentable.id)
    elsif comment.commentable_type == 'Item'
      redirect_to group_list_item_path(comment.commentable.list.group_id, comment.commentable.list_id, comment.commentable.id)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :commentable_id, :commentable_type, :text)
  end
end
