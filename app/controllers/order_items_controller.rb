class OrderItemsController < ApplicationController
  def index
    @order_items = OrderItem.all
  end

  def new
    @order_item = OrderItem.new
  end

  def create
    @product = Product.find_by(id: params[:product_id])

    if @product.nil?
      flash[:error] = "Product no longer exists."
      return head :not_found
    end

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
        # params[:quantity].to_i to add up the quantity
        if @product.inventory < params[:quantity].to_i
          flash[:error] = "Could not add item to order (not enough in stock)"
          redirect_to product_path(@product.id)
        else
          current_item[:quantity] += params[:quantity].to_i
          @product.decrease_inventory(params[:quantity].to_i)
          current_item.save
          flash[:success] = "Successfully updated order item"
          redirect_to order_path(@order_id)
        end
        return
      end
    end

    if @product.inventory < 1 || @product.inventory < params[:quantity].to_i
      flash[:error] = "Could not add item to order (not enough in stock)"
      redirect_to product_path(@product.id)
      return
    end

    order_item = OrderItem.new({
      product_id: params[:product_id],
      quantity: params[:quantity].to_i,
      order_id: session[:order_id],
    })

    if order_item.save
      @product.decrease_inventory(params[:quantity].to_i)
      flash[:success] = "Item added to order"
      redirect_to order_path(@order_id)
    else
      flash[:error] = "Could not add item to order"
      redirect_to order_path(@order_id)
    end
  end

  def destroy
    order_item = OrderItem.find_by(id: params[:id].to_i)
    if order_item
      if order_item.destroy
        product = Product.find_by(id: order_item.product_id)
        product.inventory_back(order_item.quantity)
        flash[:success] = "#{order_item.product.name} successfully removed from your basket!"
      else
        flash.now[:error] = "A problem occurred. #{order_item.product.name} was not successfully removed from your basket."
      end
    end
    return redirect_to order_path(session[:order_id])
  end

  def update
   order_item = OrderItem.find_by(id: params[:id].to_i)
    if order_item.nil?
      head :not_found
      return
    elsif order_item.update(order_item_params)
      redirect_to order_path(session[:order_id]) # go to the index so we can see the driver in the list
      return
    else # save failed :(
      render :edit, status: :bad_request # show the new driver form view again
      return
    end
  end

  private

  def order_item_params
    return params.require(:order_item).permit(:quantity, :order_id, :product_id)
  end
end
