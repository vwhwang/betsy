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
    if !session[:merchant_id]
      flash.now[:error] = "You must be logged in to create a product"
    end
  end

  def create
    if session[:merchant_id]
      @product = Product.new(product_params) 
      @product.merchant_id = session[:merchant_id]
      if @product.save 
        flash[:success] = "#{@product.name} has been added to the product database"
        redirect_to product_path(@product.id)
        return
      else
        flash.now[:error] = "Something happened. #{@product.name} was not added."
        render :new, status: :bad_request
        return
      end
    else
      flash.now[:error] = "You must be logged in to create a product"
    end
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :inventory, :category, :merchant_id)
  end
  
end
