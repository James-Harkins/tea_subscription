require "rails_helper"

describe "POST /subscriptions request" do
  describe "happy path" do
    it "should return a 200 response showing the updated subscription details" do
      customer = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")

      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      subscription_1 = customer.subscriptions.create!(title: "Tony's Monthly Subscriptions", price: 19.99, frequency: 0)
      subscription_2 = customer.subscriptions.create!(title: "Tony's Quarterly Subscriptions", price: 49.99, frequency: 1)

      subscription_tea_1 = subscription_1.subscription_teas.create!(tea_1)
      subscription_tea_2 = subscription_1.subscription_teas.create!(tea_3)
      subscription_tea_3 = subscription_1.subscription_teas.create!(tea_4)
      subscription_tea_4 = subscription_2.subscription_teas.create!(tea_2)
      subscription_tea_5 = subscription_3.subscription_teas.create!(tea_3)

      params = {
        cancel: true
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/subscriptions/#{subscription_2.id}", headers: headers, params: params.to_json

      expect(response).to have_http_status(200)

      response_body = JSON.parse(response.body, symbolize_names: true)
      subscription = response_body[:data]

      expect(subscription[:attributes][:status]).to eq("Canceled")

      expect(Subscription.find(subscription_1.id).status).to eq("Active")
      expect(Subscription.find(subscription_2.id).status).to eq("Canceled")
    end
  end

  describe "sad path" do
    it "should return a 400 error if no cancel params are sent" do
      customer = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")

      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      subscription_1 = customer.subscriptions.create!(title: "Tony's Monthly Subscriptions", price: 19.99, frequency: 0)
      subscription_2 = customer.subscriptions.create!(title: "Tony's Quarterly Subscriptions", price: 49.99, frequency: 1)

      subscription_tea_1 = subscription_1.subscription_teas.create!(tea_1)
      subscription_tea_2 = subscription_1.subscription_teas.create!(tea_3)
      subscription_tea_3 = subscription_1.subscription_teas.create!(tea_4)
      subscription_tea_4 = subscription_2.subscription_teas.create!(tea_2)
      subscription_tea_5 = subscription_3.subscription_teas.create!(tea_3)

      params = {
        frequency: "Yearly"
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/subscriptions/#{subscription_2.id}", headers: headers, params: params.to_json

      expect(response).to have_http_status(400)

      expect(response[:errors]).to eq("You must send a param of cancel with a value of either true or false")
    end

    it "should return a 400 error if cancel params do not equal either true or false" do
      customer = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")

      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      subscription_1 = customer.subscriptions.create!(title: "Tony's Monthly Subscriptions", price: 19.99, frequency: 0)
      subscription_2 = customer.subscriptions.create!(title: "Tony's Quarterly Subscriptions", price: 49.99, frequency: 1)

      subscription_tea_1 = subscription_1.subscription_teas.create!(tea_1)
      subscription_tea_2 = subscription_1.subscription_teas.create!(tea_3)
      subscription_tea_3 = subscription_1.subscription_teas.create!(tea_4)
      subscription_tea_4 = subscription_2.subscription_teas.create!(tea_2)
      subscription_tea_5 = subscription_3.subscription_teas.create!(tea_3)

      params = {
        cancel: "update to true"
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/subscriptions/#{subscription_2.id}", headers: headers, params: params.to_json

      expect(response).to have_http_status(400)

      expect(response[:errors]).to eq("You must send a param of cancel with a value of either true or false")
    end
  end
end
