class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to question_path(params[:question_id]), notice: 'Your answer successfully created'
    else
      @question = Question.find params[:question_id]
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find params[:id]
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
