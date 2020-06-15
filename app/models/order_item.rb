class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def self.by_order_id(id)
    order_items = OrderItem.all

    items_list = order_items.select do |item|
      item.order_id == id
    end

    return items_list
  end

  def total_per_item
    return self.quantity * self.product.price
  end
end
