class Order < ApplicationRecord
  has_many :order_items

  def order_purchase
  # Reduces the number of inventory for each product 
    self.order_items.each do |item|
      product = item.product
      product.inventory -= (item.quantity)
      product.save!
    end

  # Changes the order state from "pending" to "paid"
    self.status = "paid"
    self.save
  end

  def clear_cart
    session[:order_id] = nil
  end
end
