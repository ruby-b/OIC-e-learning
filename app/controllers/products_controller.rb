class ProductsController < ApplicationController
  layout 'front'

  def index
    @products = @q.result
  end

  def show
    @product = Book.find(params[:id])
  end
end
