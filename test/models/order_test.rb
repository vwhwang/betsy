require "test_helper"

describe Order do

  describe "order_purchase" do 
    it "reduces the number of inventory for each product" do 

    end

    it "changes the order state from pending to paid" do 

    end

  end 

  # #   Reduces the number of inventory for each product 
  #   # loop through order items
      
  #   self.order_items.each do |item|
  #     # find product - 
  #       product = Product.find_by(id: item.product_id)
  #     # inventory -= quantity of the order item
  #       product.inventory -= (item.quantity)
  #       product.save
  #     end

  # #   Changes the order state from "pending" to "paid"
  #     self.status = "paid"
  #     self.save
      
end
