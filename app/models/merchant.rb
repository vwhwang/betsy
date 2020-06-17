class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    # Note that the merchant has not been saved.
    # We'll choose to do the saving outside of this method
    return merchant
  end

  def total_revenue
    @total_revenue = 0
    self.order_items.each do |item|
      if item.order.status == "paid" || item.order.status == "complete"
        @total_revenue += item.total_per_item
      end
    end
    return @total_revenue
  end

  def num_orders(status)
    total_orders = 0

    self.order_items.each do |order_item|
      if order_item.order.status == status
        total_orders += 1
      end
    end

    return total_orders
  end

  def orders_by_status(status)
    order_by_status = self.order_items.select do |order_item|
      order_item.order.status == status
    end
    return order_by_status
  end

  def total_by_status(status)

    total_by_status = 0
    self.order_items.each do |item|
      if item.order.status == status
        total_by_status += item.order.order_cost
      end
    end
    return total_by_status
  end

  def find_orders

    products = Product.where(merchant: id, order_items: true)
    #storage for order_ids

    #loop through each product in products 
    #loop through each order item - grabbing the order_id
    #handle duplicates

    #return order_ids

    #loop through order_ids and create array of order records 
    #return order records 
    
  end
end
