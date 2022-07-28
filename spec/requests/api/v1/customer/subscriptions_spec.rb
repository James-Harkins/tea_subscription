require "rails_helper"

describe "GET /customer/:id/subscriptions request" do
  describe "happy path" do
    it "should return all of a given customer's subscriptions regardless of status" do
      customer_1 = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")
      customer_2 = Customer.create!(first_name: "Junior", last_name: "Soprano", email: "varsity_athlete@gmail.com", address: "North Jersey")

      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      subscription_1 = customer_1.subscriptions.create!(title: "Tony's Monthly Subscriptions", price: 19.99, frequency: 0)
      subscription_2 = customer_1.subscriptions.create!(title: "Tony's Quarterly Subscriptions", price: 49.99, frequency: 1)
      subscription_3 = customer_2.subscriptions.create!(title: "Uncle Jun's Monthly Subscriptions", price: 29.99, frequency: 0)

      subscription_tea_1 = subscription_1.subscription_teas.create!(tea: tea_1)
      subscription_tea_2 = subscription_1.subscription_teas.create!(tea: tea_3)
      subscription_tea_3 = subscription_1.subscription_teas.create!(tea: tea_4)
      subscription_tea_4 = subscription_2.subscription_teas.create!(tea: tea_2)
      subscription_tea_5 = subscription_2.subscription_teas.create!(tea: tea_3)
      subscription_tea_6 = subscription_3.subscription_teas.create!(tea: tea_1)

      headers = {"CONTENT_TYPE" => "application/json"}

      get "/api/v1/customers/#{customer_1.id}/subscriptions", headers: headers

      expect(response).to have_http_status(200)

      response_body = JSON.parse(response.body, symbolize_names: true)
      subscriptions = response_body[:data]

      expect(subscriptions.length).to eq(2)
      expect(subscriptions[0][:attributes][:teas].length).to eq(3)
      expect(subscriptions[1][:attributes][:teas].length).to eq(2)
    end

    it "should return an empty array if the customer has no subscriptions" do
      customer_1 = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")
      customer_2 = Customer.create!(first_name: "Junior", last_name: "Soprano", email: "varsity_athlete@gmail.com", address: "North Jersey")

      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      subscription_1 = customer_1.subscriptions.create!(title: "Tony's Monthly Subscriptions", price: 19.99, frequency: 0)
      subscription_2 = customer_1.subscriptions.create!(title: "Tony's Quarterly Subscriptions", price: 49.99, frequency: 1)

      subscription_tea_1 = subscription_1.subscription_teas.create!(tea: tea_1)
      subscription_tea_2 = subscription_1.subscription_teas.create!(tea: tea_3)
      subscription_tea_3 = subscription_1.subscription_teas.create!(tea: tea_4)
      subscription_tea_4 = subscription_2.subscription_teas.create!(tea: tea_2)
      subscription_tea_5 = subscription_2.subscription_teas.create!(tea: tea_3)

      headers = {"CONTENT_TYPE" => "application/json"}

      get "/api/v1/customers/#{customer_2.id}/subscriptions", headers: headers

      expect(response).to have_http_status(200)

      response_body = JSON.parse(response.body, symbolize_names: true)
      subscriptions = response_body[:data]

      expect(subscriptions.length).to eq(0)
    end
  end

  describe "sad path" do
    it "should return a 400 error if a bad customer id is passed through" do
      customer_1 = Customer.create!(first_name: "Tony", last_name: "Soprano", email: "gabagool@gmail.com", address: "North Jersey")
      customer_2 = Customer.create!(first_name: "Junior", last_name: "Soprano", email: "varsity_athlete@gmail.com", address: "North Jersey")

      tea_1 = Tea.create!(title: "Green", description: "It's Green", temperature: 120, brew_time: 240)
      tea_2 = Tea.create!(title: "Earl Grey", description: "It's Grey", temperature: 120, brew_time: 240)
      tea_3 = Tea.create!(title: "Black", description: "It's Black", temperature: 120, brew_time: 240)
      tea_4 = Tea.create!(title: "English Breakfast", description: "It's English", temperature: 120, brew_time: 240)

      subscription_1 = customer_1.subscriptions.create!(title: "Tony's Monthly Subscriptions", price: 19.99, frequency: 0)
      subscription_2 = customer_1.subscriptions.create!(title: "Tony's Quarterly Subscriptions", price: 49.99, frequency: 1)
      subscription_3 = customer_2.subscriptions.create!(title: "Uncle Jun's Monthly Subscriptions", price: 29.99, frequency: 0)

      subscription_tea_1 = subscription_1.subscription_teas.create!(tea: tea_1)
      subscription_tea_2 = subscription_1.subscription_teas.create!(tea: tea_3)
      subscription_tea_3 = subscription_1.subscription_teas.create!(tea: tea_4)
      subscription_tea_4 = subscription_2.subscription_teas.create!(tea: tea_2)
      subscription_tea_5 = subscription_2.subscription_teas.create!(tea: tea_3)
      subscription_tea_6 = subscription_3.subscription_teas.create!(tea: tea_1)

      headers = {"CONTENT_TYPE" => "application/json"}

      get "/api/v1/customers/999999999999/subscriptions", headers: headers

      expect(response).to have_http_status(404)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:error]).to eq("Couldn't find Customer with 'id'=999999999999")
    end
  end
end
