require "test_helper"

describe OrderItemsController do
  describe "Create an order Item" do
    it "can create an Order Item with a new Order" do
      @product = products(:product_1)
      # assert that new Order is created
      expect { post product_order_items_path(@product.id) }.must_differ "Order.count", 1

      expect(OrderItem.where(product_id: @product.id).length).must_equal 1

      must_respond_with :redirect
      expect(flash[:success]).must_equal "Item added to order"

      item = OrderItem.find_by(product_id: @product.id)
      order_nil = item.order_id.nil?
      refute(order_nil)
      expect(item.product_id).must_equal @product.id
      # expect(item.quantity).must_equal 1
    end
  end

  it "can create an Order Item in a current Order" do
    @product = products(:product_2)
    expect { post orders_path }.must_differ "Order.count", 1

    # ensure that Order Item is not creating a new Order
    expect { post product_order_items_path(@product.id) }.must_differ "Order.count", 0
    item = OrderItem.find_by(product_id: @product.id)

    must_respond_with :redirect
    # expect(item.quantity).must_equal 1
    expect(item.order_id).must_equal Order.last.id
  end
end
