require "rails_helper"

describe Subscription, type: :model do
  describe "relationships" do
    it { should have_many :subscription_teas }
    it { should have_many(:teas).through(:subscription_teas) }
    it { should belong_to :customer }
  end

  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :price }
    it { should validate_presence_of :frequency }

    it "should be initialized with a default status value of 'active'" do
      customer = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")
      subscription = customer.subscriptions.create!(title: "Tony's Monthly Subscriptions", price: 19.99, frequency: 0)

      expect(subscription.status).to eq("Active")
    end
  end
end
