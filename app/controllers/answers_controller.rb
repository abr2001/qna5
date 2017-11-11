class AnswersController < ApplicationController
  include Rated
  include Commented
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_answer, only: [:destroy, :update, :set_best]
  before_action :load_question, only: [:update, :set_best, :create]
  after_action :publish_answer, only: [:create]

  def create
    byebug
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted'
    else
      flash[:notice] = 'Only the author can delete the answer'
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      head :forbidden
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best
    else
      head :forbidden
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end

  def load_answer
    @answer = Answer.find(params[:id] || params[:answer_id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast "questions/#{@answer.question_id}/answers", @answer
  end
end
