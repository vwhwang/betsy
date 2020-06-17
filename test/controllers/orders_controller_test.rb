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
      expect(flash[:error]).must_equal "this order was already confirmed"
      must_redirect_to  orders_path
      expect(paid_order.reload.name).must_equal "bob"
    end  

    it "can not update order if no order items " do 
      empty_order = orders(:order_with_no_items)

      order_hash = {
        order: {
          name: "updated bob"
        }
      } 

      expect {patch order_path(empty_order.id), params: order_hash}.must_differ "Order.count", 0 
      expect(flash[:error]).must_equal "can not make an order if cart empty"

    end 

  end 

  describe "status" do 
    it "can get status page" do 
      order = Order.first 
    
      get status_path(order.id)

      must_respond_with :ok
    end 

    it "redirect if invalid order" do 
      invalid_id = -1 

      get status_path(invalid_id)

      must_redirect_to root_path
    end 

  end 

  describe "show and index" do 
    it "can get index page" do 
      get orders_path 

      must_respond_with :ok
    end 

    it "will flash error if no session_id created" do 
    skip 
      session[:order_id] = nil 
      expect(flash[:error]).must_equal "huh"
    end 


    it "can get show page" do 
      order = Order.first 

      get order_path(order.id)

      must_respond_with :found
    end 

    it "will redirect to root if no order id" do
      
      invalid_id = -1 

      get order_path(invalid_id)

      must_redirect_to root_path

    end 
  end 


  describe "create " do 
    it "can create a new order" do 
      order_hash = {
        order: {
          name: "may day",
          email: "mayday@.com",
          address: "123 st",
          status: "pending"
        }
      } 
   
      expect{post orders_path, params: order_hash}.must_differ "Order.count", 1 

    end 
  end 

end
