require "test_helper"

describe ReviewsController do
  describe "new" do
    it "responds with success" do
      product = products(:product_1)
      # Act
      get new_product_review_path(product.id)
      
      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new review with valid information and redirect" do
      product = products(:product_1)
    
      # Arrange
      review_hash = {
        review: {
          rating: 4,
          description: "it's great",
          product: product
        },
      }
      
      # Act-Assert
      expect {
        post product_reviews_path(product.id), params: review_hash
      }.must_change "Review.count", 1
      
      new_review = Review.find_by(description: review_hash[:review][:description])
      expect(new_review.description).must_equal review_hash[:review][:description]
      expect(new_review.rating).must_equal review_hash[:review][:rating]
      expect(new_review.product).must_equal review_hash[:review][:product]
      expect(flash[:success]).must_include "Thank you for reviewing"

      must_redirect_to product_path(product.id)
    end

    it "does not create a review if the signed in user is the merchant associated with the product" do
      perform_login
      product = products(:product_1)
    
      # Arrange
      review_hash = {
        review: {
          rating: 4,
          description: "it's great",
          product: product
        },
      }
      
      # Act-Assert
      expect {
        post product_reviews_path(product.id), params: review_hash
      }.must_change "Review.count", 0
    end

    # it "does not create a review if the product does not exist" do
    #   review_hash = {
    #     review: {
    #       rating: 4,
    #       description: "it's great",
    #       product_id: -1
    #     },
    #   }
      
    #   # Act-Assert
    #   expect {
    #     post product_reviews_path(-1), params: review_hash
    #   }.must_differ "Review.count", 0
            
    #   must_respond_with :bad_request
    # end
  end
end
