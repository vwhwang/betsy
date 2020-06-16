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

  def order_cost
    @sum = 0 
    self.order_items.each do |item|
      @sum += item.product.price
    end 
    return @sum 
  end 

  # method for emptying cart without purchasing; potentially moving to controller?
  # def clear_cart
  #   self.order_items.each do |item|
  #     item.destroy
  #   end
  # end
end
