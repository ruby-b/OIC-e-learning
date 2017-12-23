class ProductsController < ApplicationController
  layout 'front'

  def index
    @products = @q.result.by_tags(params[:tag_id])
  end

  def show
    @product = Book.find(params[:id])
  end
end
