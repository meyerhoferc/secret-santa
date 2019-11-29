class CommentsController < ApplicationController

  def create
    comment = Comment.new(comment_params)
    if comment.save
      flash[:notice] = 'Comment added.'
    else
      flash[:warning] = 'Comment could not be saved.'
    end
    redirect_to comment.commentable
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
    redirect_to comment.commentable
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :commentable_id, :commentable_type, :text)
  end
end
