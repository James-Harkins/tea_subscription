class AddCustomerToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_reference :subscriptions, :customer, foreign_key: true
  end
end
