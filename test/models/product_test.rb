require "test_helper"

describe Product do
  describe 'relations' do 
    it "can have many order_items" do 
      product = products(:product_1)
      order = orders(:order_1)

      count = product.order_items.count

      order_item1 = OrderItem.create(product: product,quantity:1 , order:order)
      order_item2 = OrderItem.create(product: product,quantity:1 , order:order)
      expect(product.reload.order_items.count).must_equal count + 2 

    end 

    it "can have many reviews" do 
      product = products(:product_1)

      count = product.reviews.count

      review_1 = Review.create(product: product, rating: 3)
      expect(product.reload.reviews.count).must_equal count + 1 
    end 
  end 

  describe 'average_rating' do
    it 'returns correct rating for a product' do
      product = products(:product_1)

      expect(product.average_rating).must_include "3.0"
    end

    it 'returns no reviews yet for product with no reviews' do
      product = products(:product_4)

      expect(product.average_rating).must_equal "No reviews yet"
    end
  end
end
