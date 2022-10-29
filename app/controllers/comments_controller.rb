class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: %i[create]
  before_action :find_comment, only: %i[update destroy]

  def create
    @comment = @commentable.comments.create((comments_params).merge(author: current_user))
  end

  def destroy
    
    if @comment.commentable.instance_of?(Question)
      @question = @comment.commentable
    elsif @comment.commentable.instance_of?(Answer)
      @question = @comment.commentable.question
    end
    
    @comment.destroy
  end
  
  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(params["#{commentable_name.singularize}_id"])
  end

  def commentable_name
    params[:commentable]
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end