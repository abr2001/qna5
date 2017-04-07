module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_ratable, only: [:rate, :cancel_rate]
    before_action :check_author, only: [:rate, :cancel_rate]
  end

  def rate
    @rate = @ratable.rates.build(user: current_user, value: params[:negative].present? ? -1 : 1)

    respond_to do |format|
      if @rate.save
        format.json { render json: {rating: @ratable.rating, rate: current_user.rate_of(@ratable), id: @ratable.id } }
      else
        format.json { render json: { errors: @rate.errors.full_messages, id: @ratable.id }, status: :unprocessable_entity }
      end
    end
  end

  def cancel_rate
    unless current_user.already_has_rate_of?(@ratable)
      head :forbidden
      return
    end

    rate = @ratable.rates.where(user_id: current_user).first

    respond_to do |format|
      if rate.destroy
        format.json { render json: {rating: @ratable.rating, rate: current_user.rate_of(@ratable), id: @ratable.id } }
      else
        head :unprocessable_entity
      end
    end
  end


  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_ratable
    @ratable = model_klass.find(params[:id])
  end

  def check_author
    if current_user.author_of?(@ratable)
      head :forbidden
      return
    end
  end

end
