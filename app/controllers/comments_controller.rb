class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private
    def comment_params
      params.require(:comment).permit(:id, :body);
    end

    def load_commentable
      @commentable = params[:commentable].classify.constantize.find(params[commentable_id])
    end

    def commentable_id
      commentable_name.singularize + '_id'
    end

    def publish_comment
      return if @comment.errors.any?
      question_id = params['question_id'].present? ? params['question_id'] : @comment.commentable.question_id
      ActionCable.server.broadcast "questions/#{question_id}/comments",
        ApplicationController.render(
          partial: 'comments/comment_channel',
          locals: {comment: @comment}
        )
    end
end
