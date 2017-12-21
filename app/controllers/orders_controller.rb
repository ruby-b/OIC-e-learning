class OrdersController < ApplicationController
  layout 'front'

  def new
    @line_items = @current_cart.line_items
    if @line_items.empty?
      redirect_to products_index_url
      return
    end
    @order = Order.new
  end

  def confirm
    @line_items = @current_cart.line_items
    @order = Order.new(order_params)
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      OrderMailer.confirm_mail(@order).deliver
      redirect_to root_path, notice: '注文が正常に登録されました'
    else
      redirect_to root_path, alert: '注文の登録ができませんでした'
    end
  end

  private

  def order_params
    params.require(:order).permit(:address,:quantity,:book_id,:user_id)
  end
end
