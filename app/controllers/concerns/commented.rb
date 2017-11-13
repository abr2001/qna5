module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:comment]
    after_action :publish_comment, only: [:comment]
  end

  def comment
    @comment = @commentable.comments.create(user: current_user, body: params[:body])
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments",
      {
        comment: JSON.parse(@comment.to_json),
        html: ApplicationController.render(
          locals: { item: @commentable },
          partial: 'comments/list'
        )
      }
    )
  end



end
