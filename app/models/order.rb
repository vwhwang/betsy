class Order < ApplicationRecord
  has_many :order_items

  # create_table "orders", force: :cascade do |t|
  #   t.string "name"
  #   t.string "email"
  #   t.string "address"
  #   t.integer "credit_card"
  #   t.date "credit_card_exp"
  #   t.datetime "created_at", precision: 6, null: false
  #   t.datetime "updated_at", precision: 6, null: false
  #    t.string "status"
  # end


  # Purchasing an order makes the following changes:

  def order_purchase
  #   Reduces the number of inventory for each product 
    # loop through order items
    p self.order_items
      
      self.order_items.each do |item|
      # find product - 
        product = Product.find_by(id: item.product_id)
        p "product.inventory before = #{product.inventory}"
      # inventory -= quantity of the order item
        p "item.quantity = #{item.quantity}"
        product.inventory -= (item.quantity)
        product.save
        p "product.inventory after = #{product.inventory}"
      end

  #   Changes the order state from "pending" to "paid"
      self.status = "paid"
      self.save
      
  end

  def clear_cart
  #   Clears the current cart
  end

  # def create
  #   @product = Product.find_by(id: params[:product_id])

  #   # if product does not exist, then return to head
  #   if @product.nil?
  #     flash[:error] = "Product no longer exists."
  #     return head :not_found
  #   end

  #   # create order items hash
  #   order_items = {
  #     product_id: params[:product_id].to_i,
  #     quantity: params[:quantity].to_i,
  #     order_id: session[:order_id],
  #   }

  #   # if order does not exist yet in session, create new order
  #   if session[:order_id].nil?
  #     # creates a new order if one doesn't exist
  #     @order = Order.create
  #     @order_id = @order.id

  #     session[:order_id] = @order_id
  #   # if order has already been created in session, 
  #   else
  #     # Use current order if there is alrady one:
  #     @order_id = session[:order_id]
  #     current_order = Order.find(@order_id)

  #     # if product has already been added to order, find and save to current_item
  #     current_item = current_order.order_items.find_by(product_id: params[:product_id])
  #     # checks if item is already in order, updates by 1 if so
  #     if current_item
  #       current_item[:quantity] += 1
  #       current_item.save
  #       flash[:success] = "Successfully updated order item"
  #       redirect_to product_path(@product.id)
  #       return
  #     end
  #   end


  #   order_item = OrderItem.new(order_items)

  #   if order_item.save
  #     flash[:success] = "Item added to order"
  #     if session[:order_id].nil?
  #       session[:order_id] = order_item.order_id
  #     end
  #     redirect_to product_path(order_item.product_id)
  #   else
  #     flash[:error] = "Could not add item to order"
  #     redirect_to products_path
  #   end
  # end


end
