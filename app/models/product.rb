class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :order_items
  has_many :reviews
  validates :name, :price, :inventory, :merchant_id, presence: true
  validates :active, inclusion: { in: [ true, false ] }

  def decrease_inventory(quantity)
    self.inventory -= quantity
    self.save
  end

  def inventory_back(quantity)
    self.inventory += quantity
    self.save
  end
  
  def average_rating
    return "No reviews yet" if self.reviews.length == 0

    average = self.reviews.average(:rating)
    return "#{average.round(2)} out of 5"
  end

  def reviews_length
    length = self.reviews.length

    return "#{length} review" if length == 1
    return "#{length} reviews"
  end

  def inventory_check
    return "Limited stock! Only #{inventory} left" if self.inventory <= 3
    return "#{inventory} in stock"
  end
end
