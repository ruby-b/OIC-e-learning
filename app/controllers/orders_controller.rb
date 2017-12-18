class OrdersController < ApplicationController
  def new
    @product  = Book.find(params[:book_id].to_i)
    @order    = Order.new
    render layout: 'front'
  end
end
