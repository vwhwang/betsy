class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def self.by_merchant(id)
    order_items = OrderItem.all
    result = []
    order_items.each do |item|
      if Product.find_by(id: item.product_id).merchant_id == id
        result << item
      end
    end
    return result
  end

  def self.by_order_id(id)
    order_items = OrderItem.all
    
    items_list = order_items.select do |item|
      item.order_id == id
    end

    return items_list
  end
end
