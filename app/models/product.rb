class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_many :reviews
  # TODO: figure out how to make name unique within category (uniqueness: {scope: :category})
  validates :name, presence: true
  validates :price, presence: true
  validates :inventory, presence: true
  validates :merchant_id, presence: true
end
