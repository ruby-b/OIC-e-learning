class ProductsController < ApplicationController
  def index
    @products = Book.all
    render layout: 'front'
  end

  def show
    @products = Book.find(params[:id])
  end
end
