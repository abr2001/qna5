class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params_quesions)
    if @question.save
      redirect_to questions_path
    else
      render :new
    end
  end

  private

  def params_quesions
    params.require(:question).permit(:title, :body)
  end

end
