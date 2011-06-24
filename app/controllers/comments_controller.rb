class CommentsController < ApplicationController
  
  def create
    if current_user
      model_name = params[:commentable].classify.constantize
      @commentable = model_name.find(params[:commentable_id])
      @comment = @commentable.comments.build(params[:comment])
      @comment.user = current_user
      @comment.save
    else
      flash[:error] = 'You must be logged in to comment.'
    end
    
    redirect_to(:back)
  end
  
end