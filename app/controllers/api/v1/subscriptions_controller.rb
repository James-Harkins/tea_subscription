class Api::V1::SubscriptionsController < ApplicationController
  def create
    subscription = Subscription.create!(subscription_params)
    SubscriptionTea.create_multiple(subscription.id, params[:teas])
    render json: SubscriptionSerializer.new(subscription), status: :created
  end

  private

  def subscription_params
    params.permit(:customer_id, :title, :frequency, :price)
  end
end
