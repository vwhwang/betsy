require "test_helper"

describe OrdersController do
  describe "update" do
    it "will update order " do 
      order = orders(:order_1)
      order_hash = {
        order: {
          name: "updated jessica"
        }
      } 
      expect {patch order_path(order.id), params: order_hash}.must_differ "Order.count", 0 
      expect(order.reload.name).must_equal "updated jessica"

    end 


    it "can not update orders with status paid" do 
      paid_order = orders(:paid_order)
      order_hash = {
        order: {
          name: "updated bob"
        }
      } 
      
      expect {patch order_path(paid_order.id), params: order_hash}.must_differ "Order.count", 0 
        
      must_redirect_to  orders_path
      expect(paid_order.reload.name).must_equal "bob"
    end  

  end 

  describe "status" do 
    it "can get status page" do 
      paid_order = orders(:paid_order)
    
      get status_path(paid_order.id)

      must_respond_with :ok
    end 
  end 
end
