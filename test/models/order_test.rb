require "test_helper"

describe Order do

  describe "order_purchase" do 
    it "reduces the number of inventory for each product" do 

      order = orders(:order_1)
      order_item1 = order_items(:order_item_1)
      order_item2 = order_items(:order_item_2)

      order_item1.order_id = order.id
      order_item2.order_id = order.id

      product1 = Product.find_by(id: order_item1.product_id)
      product1_count = product1.inventory

      product2 = Product.find_by(id: order_item2.product_id)
      product2_count = product2.inventory

      puts "product1.inventory before = #{product1.inventory}"
      order.order_purchase

      order.reload
      order_item1.reload
      order_item2.reload
      product1.reload
      product2.reload
      
      puts "product1.inventory after = #{product1.inventory}"
      
      expect(product1.inventory).must_equal product1_count - order_item1.quantity
      expect(product2.inventory).must_equal product2_count - order_item2.quantity
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
