class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      notice = 'Your answer successfully deleted'
    else
      notice = 'Only the author can delete the answer'
    end
    redirect_to question_path(params[:question_id]), notice: notice
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end


end
