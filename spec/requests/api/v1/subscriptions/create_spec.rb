require "rails_helper"

describe "POST /subscriptions request" do
  describe "happy path" do
    it "should return 201 with new subscription info", :vcr do
      customer = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")
      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      params = {
        customer_id: customer.id,
        title: "Monthly Subscription",
        price: 19.99,
        frequency: "Monthly",
        teas: [tea_2.id, tea_4.id]
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/subscriptions", headers: headers, params: params.to_json

      expect(response).to have_http_status(201)

      response_body = JSON.parse(response.body, symbolize_names: true)
      subscription = response_body[:data]

      expect(subscription[:type]).to eq("subscription")
      expect(subscription[:attributes][:title]).to eq("Monthly Subscription")
      expect(subscription[:attributes][:price]).to eq(19.99)
      expect(subscription[:attributes][:frequency]).to eq("Monthly")
      expect(subscription[:attributes][:status]).to eq("Active")
      expect(subscription[:attributes][:teas]).to be_an Array
      expect(subscription[:attributes][:teas][0][:id]).to eq(tea_2.id)
      expect(subscription[:attributes][:teas][1][:id]).to eq(tea_4.id)
    end
  end

  describe "sad path" do
    it "should return 400 with no customer id" do
      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      params = {
        title: "Monthly Subscription",
        price: 19.99,
        frequency: "Monthly",
        teas: [tea_2.id, tea_4.id]
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/subscriptions", headers: headers, params: params.to_json

      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to have_key(:errors)
    end

    it "should return 400 with no teas" do
      customer = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")
      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      params = {
        customer_id: customer.id,
        title: "Monthly Subscription",
        price: 19.99,
        frequency: "Monthly",
        teas: []
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/subscriptions", headers: headers, params: params.to_json

      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to have_key(:errors)
    end
  end
end
