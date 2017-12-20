class Order < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum status: {registered: 0, payed: 1, delivered: 2}
end
