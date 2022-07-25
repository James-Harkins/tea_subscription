require "rails_helper"

describe TeaSubscription, type: :model do
  describe "relationships" do
    it { should belong_to :tea }
    it { should belong_to :subscriptions }
  end
end
