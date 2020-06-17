class OrdersController < ApplicationController

  skip_before_action :require_login, only: [:index, :create, :show, :edit, :update, :status]

  def index
    @orders = Order.all
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
      # Use current order if there is already one:
      order_id = session[:order_id]
      @order = Order.find_by(id: session[:order_id])
      @order_products = OrderItem.by_order_id(order_id)
    end
  end

  def manage
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "The order does not exist"
      redirect_to root_path
    end
  end

  def edit
    @order = Order.find_by(id: params[:id])
  end

  def status
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      redirect_to root_path
      return
    end
  end

  def update
    @order = Order.find_by(id: params[:id])

    if @order.status == "paid"
      flash[:error] = "this order was already confirmed"
      redirect_to orders_path
      return
    end

    if @order.nil?
      head :not_found
      return
    elsif @order.order_items.empty?
      flash.now[:error] = "can not make an order if cart empty"
      render :edit
      return
    elsif @order.update(order_params)
      @order.order_purchase
      # clear session order id
      session[:order_id] = nil
      flash[:success] = "Successfully made an order #{@order}"
      # TODO make confirmation page
      redirect_to status_path(@order.id)
      return
    else
      flash.now[:error] = "can not make an order"
      render :edit
      return
    end
  end

  def cancel_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "The order does not exist"
      redirect_to root_path
    end

    @order.cancel_order_inventory

    return redirect_to current_merchant_path
  end

  def complete_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "The order does not exist"
      redirect_to root_path
    end

    @order.status = "complete"
    @order.save!
    return redirect_to current_merchant_path
  end

  def order_params
    return params.require(:order).permit(:name, :email, :address, :credit_card, :credit_card_exp, :status)
  end
end
