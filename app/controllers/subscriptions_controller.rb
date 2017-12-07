class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  respond_to :js

  def create
    respond_with(@subscription = Subscription.create(subscription_params.merge(user: current_user)), template: 'subscriptions/action')
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    respond_with(@subscription.destroy, template: 'subscriptions/action')
  end

  private
  def subscription_params
    params.require(:subscription).permit(:question_id)
  end
end
