class ProductsController < ApplicationController
  layout 'front'

  def index
    @products = Book.all
  end

  def show
    @product = Book.find(params[:id])
  end
end
