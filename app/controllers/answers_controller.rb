class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_answer, only: [:destroy, :update, :set_best]
  before_action :load_question, only: [:update, :set_best, :create]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    if current_user.  author_of?(@answer)
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
      render status: :forbidden
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.set_best
    else
      render status: :forbidden
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id] || params[:answer_id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end


end
