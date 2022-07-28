class Api::V1::Customer::SubscriptionsController < ApplicationController
  before_action :find_customer_subscriptions

  def index
    render json: SubscriptionSerializer.new(@customer_subscriptions)
  end

  private

  def find_customer_subscriptions
    @customer_subscriptions = begin
      Customer.find(params[:id]).subscriptions
    rescue
      render_not_found
    end
  end
end
