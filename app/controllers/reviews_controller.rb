class ReviewsController < ApplicationController
  before_action :get_product

  def new
    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end

    if @product.merchant_id == session[:merchant_id]
      flash[:error] = "You cannot review your own products"
      redirect_to request.referrer
    else
      @review = @product.reviews.new
    end
  end
  
  def create
    @review = @product.reviews.new(review_params)
    product = Product.find(params[:product_id])
    if product.merchant_id == session[:merchant_id]
      flash[:error] = "You cannot review your own products"
      redirect_to request.referrer
    else
      if @review.save
        flash[:success] = "Thank you for reviewing #{product.name}"
        redirect_to request.referrer
      else
        flash[:warning] = "A problem occurred: Could not create review"
        redirect_to request.referrer
      end
    end
  end
  
  private

  def get_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    return params.require(:review).permit(:rating, :description)
  end
end
