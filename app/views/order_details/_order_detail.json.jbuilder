json.extract! order_detail, :id, :book_id, :order_id, :quantity,
              :created_at, :updated_at
json.url order_detail_url(order_detail, format: :json)
