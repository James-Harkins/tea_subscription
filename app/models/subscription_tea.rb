class SubscriptionTea < ApplicationRecord
  belongs_to :tea
  belongs_to :subscription

  def self.create_multiple(subscription_id, tea_ids)
    tea_ids.each do |tea_id|
      SubscriptionTea.create!(subscription_id: subscription_id, tea_id: tea_id)
    end
  end
end
