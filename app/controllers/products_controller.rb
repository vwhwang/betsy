class ProductsController < ApplicationController
  def index 
    @products = Product.all
  end 

  def show 
    product_id = params[:id]
    @product = Product.find_by(id: product_id)

    if @product.nil?
      redirect_to products_path
      return 
    end 
  end 
  
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params) 
    if @product.save 
      flash[:success] = "#{@product.name} has been added to the product database"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something happened. #{@product.name} was not added."
      render :new, status: :bad_request
      return
    end
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :inventory, :category, :merchant_id)
  end
  
end
