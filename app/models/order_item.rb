class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Return true if there is an inventory of the product.
  def available?(quantity)
    inventory - quantity > 0 ? true : false
  end

  def decrease_inventory(quantity)
    self.available_inventory -= quantity
    self.save
  end
end
