require "rails_helper"

describe Subscription, type: :model do
  describe "relationships" do
    it { should have_many :tea_subscriptions }
    it { should have_many(:subscriptions).through(:tea_subscriptions) }
    it { should belong_to :customer }
  end

  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :price }
    it { should validate_presence_of :status }
    it { should validate_presence_of :frequency }
  end
end
