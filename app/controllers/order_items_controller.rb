class OrderItemsController < ApplicationController
  def index
    @order_items = OrderItem.all
  end

  def create
    @product = Product.find_by(id: params[:product_id])

    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end

    order_items = {
      product_id: params[:product_id].to_i,
      quantity: params[:quantity].to_i,
      order_id: session[:order_id],
    }

    if session[:order_id].nil?
      # creates a new order if one doesn't exist
      @order = Order.create
      @order_id = @order.id

      session[:order_id] = @order_id
    else
      # Use current order if there is alrady one:
      @order_id = session[:order_id]
      current_order = Order.find(@order_id)

      current_item = current_order.order_items.find_by(product_id: params[:product_id])
      # checks if item is already in order, updates by 1 if so
      if current_item
        current_item[:quantity] += 1
        current_item.save
        flash[:success] = "Successfully updated order item"
        redirect_to product_path(@product.id)
        return
      end
    end

    # if @product.inventory < 1
    #   flash[:error] = "Could not add item to order (not enough in stock)"
    #   redirect_to product_path(@product.id)
    #   return
    # end

    order_item = OrderItem.new(order_items)

    if order_item.save
      flash[:success] = "Item added to order"
      if session[:order_id].nil?
        session[:order_id] = order_item.order_id
      end
      redirect_to product_path(order_item.product_id)
    else
      flash[:error] = "Could not add item to order"
      redirect_to products_path
    end
  end

  private

  def order_item_params
    return params.require(:order_item).permit(:quantity, :order_id, :product_id)
  end
end
