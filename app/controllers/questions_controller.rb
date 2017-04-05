class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_question, only: [:show, :destroy, :update, :rate]


  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def rate
    if current_user.author_of?(@question)
      head :forbidden
      return
    end

    value = params[:negative].present? ? -1 : 1
    #binding.pry
    rate = @question.rates.where(user: current_user).first

    if rate.present? && rate.value == value
      head :forbidden
      return
    end

    Rate.transaction do
      rate.destroy if rate.present?
      rate = @question.rates.build(user: current_user, value: value)

      respond_to do |format|
        if rate.save
          format.json { render json: @question.rating }
        else
          format.json { head :unprocessable_entity }
        end
      end
    end
  end

  def create
    @question = Question.new(quesion_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def show
    @answer = Answer.new
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      notice = 'Your question successfully deleted'
    else
      notice = 'Only the author can delete the question'
    end
    redirect_to questions_path, notice: notice
  end

  def update
    if current_user.author_of?(@question)
      @question.update(quesion_params)
    else
      head :forbidden
    end
  end

  private

  def quesion_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id] || params[:question_id])
  end

end

