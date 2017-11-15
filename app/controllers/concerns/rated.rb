module Rated
  extend ActiveSupport::Concern

  included do
    before_action :set_ratable, only: [:rate, :cancel_rate]
    before_action :load_rate, only: [:cancel_rate]
    before_action :check_author, only: [:rate, :cancel_rate]
  end

  def rate
    @rate = @ratable.rates.create(user: current_user, value: params[:negative].present? ? -1 : 1)
    respond_with(@rate)
  end

  def cancel_rate
    respond_with(@rate.destroy)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_ratable
    @ratable = model_klass.find(params[:id])
  end

  def check_author
    head :forbidden if current_user.author_of?(@ratable)
  end

  def load_rate
    @rate = @ratable.rates.where(user_id: current_user).first
  end
end
