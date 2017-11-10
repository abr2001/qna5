module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:create]
  end

  def comment
    @comment = @commentable.comments.build(user: current_user, body: params[:body])

    if @comment.save
      render json: { @comment }
    else
      render json: { errors: @comment.errors.full_messages, id: @comment.id }, status: :unprocessable_entity
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_ratable
    @commentable = model_klass.find(params[:id])
  end
end
