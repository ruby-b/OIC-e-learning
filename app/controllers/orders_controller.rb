class OrdersController < ApplicationController
  before_action :set_line_items
  layout 'front'

  def new
    if @line_items.empty?
      redirect_to products_index_url
      return
    end
    @order = Order.new
  end

  def confirm
    @order = Order.new(order_params)
  end

  def create
    unless user_signed_in?
      redirect_to cart_path(@current_cart), notice: 'ログインしてください'
      return
    end
    @order = Order.new(order_params)
    if @order.save
      OrderDetail.create_items(@order, @line_items)
      OrderMailer.confirm_mail(@order).deliver
      redirect_to root_path, notice: '注文が正常に登録されました'
    else
      redirect_to root_path, alert: '注文の登録ができませんでした'
    end
  end

  def index
    @orders = Order.order("created_at DESC")
    render layout: 'application'
  end

  def show
    @order = Order.find(params[:id])
    render layout: 'application'
  end

  private

  def set_line_items
    @line_items = @current_cart.line_items
  end

  def order_params
    params.require(:order).permit(:address,:quantity,:book_id,:user_id)
  end
end
