require "test_helper"

describe ProductsController do
  describe "new" do
    it "responds with success" do
        # Act
        get new_product_path
        
        # Assert
        must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new product with valid information accurately, and redirect" do
      merchant = Merchant.create(username: "bob")
      
      # Arrange
      product_hash = {
        product: {
          name: "new product",
          price: 5.55,
          inventory: 5,
          category: "a category",
          merchant_id: merchant.id
        },
      }
      
      # Act-Assert
      expect {
        post products_path, params: product_hash
      }.must_change "Product.count", 1
      
      new_product = Product.find_by(name: product_hash[:product][:name])
      expect(new_product.name).must_equal product_hash[:product][:name]
      expect(new_product.category).must_equal product_hash[:product][:category]
      expect(new_product.price).must_equal product_hash[:product][:price]
      expect(new_product.inventory).must_equal product_hash[:product][:inventory]
      # expect(flash[:success]).must_include "added successfully"

      must_redirect_to product_path(new_product.id)
    end

    it "does not create a product if the form data violates product validations, and responds with a redirect" do
      product_hash = {
        product: {
          name: "new product",
          category: nil,
        },
      }
      
      # Act-Assert
      expect {
        post products_path, params: product_hash
      }.must_differ "Product.count", 0
            
      must_respond_with :bad_request
    end
  end
end
