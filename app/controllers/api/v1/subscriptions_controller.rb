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

  def update
    if params[:cancel]
      if params[:cancel] == true
        subscription = Subscription.find(params[:id])
        subscription.update(status: 1)
        render json: SubscriptionSerializer.new(subscription)
      else
        render json: {errors: "You must send a param of cancel with a value of either true or false"}, status: 400
      end
    else
      render json: {errors: "You must send a param of cancel with a value of either true or false"}, status: 400
    end
  end

  private

  def subscription_params
    params.permit(:customer_id, :title, :frequency, :price)
  end
end
