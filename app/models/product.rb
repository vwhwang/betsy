class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :order_items
  has_many :reviews
  validates :name, presence: true
  validates :price, presence: true
  validates :inventory, presence: true
  validates :merchant_id, presence: true

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
end
