class OrdersController < ApplicationController
  def index
    if session[:merchant_id]
      @order_items = OrderItem.by_merchant(session[:merchant_id])
    else
      @order_items = OrderItem.by_order_id(session[:order_id])
    end
  end

  def create
    if session[:order_id]
      @order = Order.new(order_params)
    else
      @order = Order.new
      session[:order_id] = @order.id
    end

    if @order.save
      # sets the session order id
      session[:order_id] = @order.id
      flash[:success] = "Successfully created order"
      return redirect_to order_path(@order.id)
    else
      flash[:error] = "Could not create order"
      return redirect_to root_path
    end
  end

  def show
    if session[:order_id].nil?
      # creates a new order if one doesn't exist
      flash[:error] = "You dont have any products to check out"
      redirect_to root_path
    else
      # Use current order if there is alrady one:
      order_id = session[:order_id]
      @order_products = OrderItem.by_order_id(order_id)
    end
  end

  # TODO: figure out empty_cart
  # def empty_cart
  #   order = Order.find_by(session[:order_id])
  #   if order
  #     order.clear_cart
  #     flash[:success] = "Cart was emptied"
  #     return redirect_to root_path
  #   else
  #     flash[:error] = "Your cart is already empty"
  #     return redirect_to root_path
  #   end
  # end

  def order_params
    return params.require(:order).permit(:name, :email, :address, :credit_card, :credit_card_exp, :status)
  end
end

