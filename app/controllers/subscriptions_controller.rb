class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_subscription, only: [:destroy]
  authorize_resource
  respond_to :js

  def create
    respond_with(@subscription = current_user.subscriptions.create(subscription_params), template: 'subscriptions/action')
  end

  def destroy
    respond_with(@subscription.destroy, template: 'subscriptions/action')
  end

  private
  def subscription_params
    params.require(:subscription).permit(:question_id)
  end

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
end
