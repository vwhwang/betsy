class ProductsController < ApplicationController

  skip_before_action :require_login, only: [:root, :show, :index]

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
    @product.active = true 
    @product.merchant_id = session[:merchant_id]
    if @product.save 
      flash[:success] = "#{@product.name} has been added to the product database"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something happened. #{@product.name} was not added to the product database"
      render :new, status: :bad_request
      return
    end
  end

  def edit 
    @product = Product.find_by(id: params[:id])

    if @product.nil? 
      head :not_found
      return 
    end 
  end 

  def update 
    @product = Product.find_by(id: params[:id])

    if @product.nil? 
      head :not_found 
      return 
    elsif @product.update(product_params)
      flash[:success] = "Successfully updated product #{@product.name}"
      redirect_to product_path(@product.id)
      return 
    else  
      flash.now[:error] = "can not update"
      render :edit
      return 
    end 
  end 

  def retire
    @product= Product.find(params[:id])

    if @product.nil? 
      head :not_found 
      return 
    end

    if @product.merchant_id != session[:merchant_id]
      flash.now[:error] = "You cannot retire a product that doesn't belong to you"
      redirect_to root_path
      return
    end

    if @product.update(active: false)
      flash[:success] = "#{@product.name} has been retired."
    else  
      flash[:error] = "#{@product.name} could not be retired."
    end 

    redirect_to current_merchant_path
    return 
  end

  def destroy 
    # currently anyone can delete work 
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      head :not_found
      return
    else   
      @product.destroy
      flash[:success] = "Art deleted"
      redirect_to products_path
      return 
    end 
  end 


  private

  def product_params
    return params.require(:product).permit(:name, :price, :inventory, :image, :merchant_id, :active, category_ids:[])
  end
  
end
