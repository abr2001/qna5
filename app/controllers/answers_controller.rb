class AnswersController < ApplicationController

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    if @answer.save
      redirect_to question_path(@answer.question_id), notice: 'Your answer successfully created'
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
