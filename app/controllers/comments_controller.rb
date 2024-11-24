class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  load_and_authorize_resource

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @commentable, notice: "Comment was successfully added." }
      end
    else
      redirect_to @commentable, alert: "Error adding comment."
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @commentable, notice: "Comment was successfully removed." }
    end
  end

  private

  def set_commentable
    if params[:post_id]
      @commentable = Post.find(params[:post_id])
    elsif params[:event_id]
      @commentable = Event.find(params[:event_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
