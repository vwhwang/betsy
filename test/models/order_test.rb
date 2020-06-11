require "test_helper"

describe Order do

  describe "order_purchase" do 
    it "reduces the number of inventory for each product" do 
      order = orders(:order_1)
      order_item1 = order_items(:order_item_1)
      order_item2 = order_items(:order_item_2)

      order_item1.order = order
      order_item2.order = order
      order_item1.save!
      order_item2.save!

      product1 = order_item1.product
      product1_count = product1.inventory

      product2 = order_item2.product
      product2_count = product2.inventory

      order.order_purchase
      
      expect(order_item1.product.reload.inventory).must_equal product1_count - order_item1.quantity
      expect(order_item2.product.reload.inventory).must_equal product2_count - order_item2.quantity
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
