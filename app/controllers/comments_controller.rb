class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  after_action :publish_comment, only: :create
  authorize_resource
  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  private
    def comment_params
      params.require(:comment).permit(:id, :body);
    end

    def load_commentable
      @commentable = params[:commentable].classify.constantize.find(params[commentable_id])
    end

    def commentable_id
      params[:commentable].singularize + '_id'
    end

    def publish_comment
      return if @comment.errors.any?
      question_id = params[:question_id].present? ? params[:question_id] : @comment.commentable.question_id
      ActionCable.server.broadcast("questions/#{question_id}/comments",
          {
            comment: @comment,
            html: ApplicationController.render(
              partial: 'comments/comment',
              locals: { comment: @comment }
            )
          }
        )
    end
end
