class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(params[:question_id]), notice: 'Your answer successfully created'
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find params[:id]
    if @answer.user == current_user
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
