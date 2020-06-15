require "test_helper"

describe OrderItemsController do
  describe "Create an order Item" do
    it "can create an Order Item with a new Order" do
      product = products(:product_2)
      # assert that new Order is created
      expect { post product_order_items_path(product.id) }.must_differ "Order.count", 1

      must_respond_with :redirect
      expect(flash[:success]).must_equal "Item added to order"

      item = OrderItem.find_by(product_id: product.id)

      order_nil = item.order_id.nil?

      expect(item.product_id).must_equal product.id
      expect(item.product_id).must_equal product.id
      expect(item.quantity).must_equal item.quantity
    end

    it "can create an Order Item with a new Order" do
      product = products(:product_2)
      # assert that new Order is created
      expect { post product_order_items_path(product.id) }.must_differ "Order.count", 1

      must_respond_with :redirect
      expect(flash[:success]).must_equal "Item added to order"

      item = OrderItem.find_by(product_id: product.id)
      order_nil = item.order_id.nil?
      expect(item.product_id).must_equal product.id
    end

    it "can create an Order Item in a current Order" do
      product = products(:product_2)
      expect { post orders_path }.must_differ "Order.count", 1

      # ensure that Order Item is not creating a new Order
      expect { post product_order_items_path(product.id) }.must_differ "Order.count", 0
      order_id = session[:order_id]

      current_order = Order.find_by(id: order_id)
      current_item = current_order.order_items.find_by(product_id: product.id)
      current_item.quantity = 5

      must_respond_with :redirect

      expect(current_item.quantity).must_equal 5
      expect(current_item.order_id).must_equal session[:order_id]
    end

    it "gets an error when there is not enough stock" do
    end

    it "will not create an Order Item if product inventory is less than 1" do
      product = products(:product_2)
      product.update(inventory: 0)

      expect { post product_order_items_path(product.id) }.must_differ "OrderItem.count", 0
      expect(flash[:error]).must_equal "Could not add item to order (not enough in stock)"
      must_respond_with :redirect
    end
  end
end
