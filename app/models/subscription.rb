class Subscription < ApplicationRecord
  belongs_to :customer
  has_many :subscription_teas
  has_many :teas, through: :subscription_teas

  validates_presence_of :title
  validates_presence_of :price
  validates_presence_of :frequency

  enum status: ["Active", "Canceled"]
  enum frequency: ["Monthly", "Quarterly", "Yearly"]
end
