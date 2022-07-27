class Api::V1::SubscriptionsController < ApplicationController
  def create
    if params[:teas].empty?
      render json: {errors: "subscription must have at least one tea"}, status: 400
    else
      subscription = Subscription.new(subscription_params)
      if subscription.save
        SubscriptionTea.create_multiple(subscription.id, params[:teas])
        render json: SubscriptionSerializer.new(subscription), status: :created
      else
        render json: {errors: subscription.errors.full_messages.to_sentence}, status: 400
      end
    end
  end

  private

  def subscription_params
    params.permit(:customer_id, :title, :frequency, :price)
  end
end
