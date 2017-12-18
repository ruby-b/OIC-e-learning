class ProductsController < ApplicationController
  def index
    @products = Book.all
    render layout: 'front'
  end

  def show
    @product = Book.find(params[:id])
    render layout: 'front'
  end
end
