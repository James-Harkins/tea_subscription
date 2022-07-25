require "rails_helper"

describe Tea, type: :model do
  describe "relationships" do
    it { should have_many :tea_subscriptions }
    it { should have_many(:subscriptions).through(:tea_subscriptions) }
    it { should have_many(:customers).through(:subscriptions) }
  end

  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :temperature }
    it { should validate_presence_of :brew_time }
  end
end
