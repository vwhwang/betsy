require "test_helper"

describe Order do

  describe "order_purchase" do 
    it "reduces the number of inventory for each product" do 
      order = orders(:order_1)
      order_item1 = order_items(:order_item_1)
      order_item2 = order_items(:order_item_4)

      product1_count = order_item1.product.inventory
      product2_count = order_item2.product.inventory 

      order.order_purchase
      
      expect(order_item1.product.reload.inventory).must_equal product1_count - order_item1.quantity
      expect(order_item1.product.reload.inventory).must_equal product2_count - order_item2.quantity
    end

    it "changes the order state from pending to paid" do 
      orders(:order_1).order_purchase

      expect(orders(:order_1).status).must_equal "paid"
    end

  end 
      
end
