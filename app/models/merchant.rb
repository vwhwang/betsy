class Merchant < ApplicationRecord
  has_many :products
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
