class AnswersController < ApplicationController
  include Rated
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_answer, only: [:destroy, :update, :set_best]
  before_action :load_question, only: [:update, :set_best, :create]
  after_action :publish_answer, only: [:create]

  respond_to :js, :json
  authorize_resource
  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def set_best
    authorize! :set_best, @answer
    respond_with(@answer.set_best)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end

  def load_answer
    @answer = Answer.find(params[:id] || params[:answer_id])
  end

  def load_question
    @question = params[:question_id] ? Question.find(params[:question_id]) : @answer.question
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("questions/#{@answer.question_id}/answers",
        {
          answer: @answer,
          user_email: @answer.user.email,
          attachments: @answer.attachments
        }
      )
  end
end
