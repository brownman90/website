# encoding: utf-8
class CommentsController < ApplicationController
  respond_to :html, :xml

  def create
    @comment = find_commentable.comments.build(comment_params)
    @comment.user = current_user

    authorize! :create, @comment

    if @comment.save
      flash[:notice] = t "comments.create.confirmation"
    end

    respond_with @comment,
      location: commentable_path(@comment, anchor: "comment_#{@comment.id}")
  end

  def edit
    @comment = Comment.find params[:id]
    authorize! :edit, @comment
    respond_with @comment
  end

  def update
    @comment = Comment.find params[:id]
    authorize! :update, @comment

    if @comment.update_attributes(comment_params)
      flash[:notice] = t "comments.update.confirmation"
    end

    respond_with @comment,
      location: commentable_path(@comment, anchor: "comment_#{@comment.id}")
  end

  def destroy
    @comment = Comment.find params[:id]
    authorize! :destroy, @comment

    if @comment.destroy
      flash[:notice] = t "comments.destroy.confirmation"
    end

    respond_with @comment, location: commentable_path(@comment)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  # This not ideal, but I don't know a better way right now.
  # There should be no mention of the Event classes in the comments controller
  def find_commentable
    return SingleEvent.find params[:single_event_id] unless params[:single_event_id].nil?
    return Event.find params[:event_id] unless params[:event_id].nil?
    return BlogPost.find params[:blog_post_id] unless params[:blog_post_id].nil?
  end

end
