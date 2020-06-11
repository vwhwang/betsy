class OrdersController < ApplicationController
  def index
    if session[:merchant_id]
      @order_items = OrderItem.by_merchant(session[:merchant_id])
    else
      @order_items = OrderItem.all
    end
  end

  def show
    if session[:order_id].nil?
      # creates a new order if one doesn't exist
      flash[:error] = "You dont have any products to check out"
      redirect_to products_path
    else
      # Use current order if there is alrady one:
      @order_id = session[:order_id]
      @order_items = OrderItem.by_order_id(@order_id)
      
    end
  end
end
