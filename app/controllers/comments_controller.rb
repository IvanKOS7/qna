class CommentsController < ApplicationController

  after_action :publish_comment, only: [:create]
  authorize_resource

  def create
    @comment = current_user.comments.build(comment: params[:comment], commentable_type: params[:commentable_type], commentable_id: params[:commentable_id])

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment }
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def publish_comment
    @inst = @comment.commentable_type.constantize.find(@comment.commentable_id)
    return  if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments_from_q_#{@comment.commentable_type == 'Question' ? @inst.id : @inst.question_id}",
        { body: ApplicationController.render(partial: 'comments/comment', locals: { c: @comment }),
          model_id: @inst.id,
          model_name: @comment.commentable_type })
  end
end
