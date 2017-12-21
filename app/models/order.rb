class Order < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :order_details, dependent: :destroy

  enum status: {registered: 0, payed: 1, delivered: 2}
end
