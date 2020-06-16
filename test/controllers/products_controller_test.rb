require "test_helper"

describe ProductsController do
  describe "index" do 
    it "will response to get /products" do 
      get products_path 

      must_respond_with :success
    end 
  end 

  describe "show" do
    it "responses to get product id" do 
      valid_id = products(:product_1).id

      get product_path(id: valid_id)

      must_respond_with :ok
    end 

    it "will redirect to products page for invalid product id" do 
      invalid_id = -1

      get product_path(id: invalid_id)

      must_redirect_to products_path 
    end 
  end
  
  describe "new" do
    it "responds with success" do
      perform_login
      
      # Act
      get new_product_path
        
      # Assert
      must_respond_with :success
    end

    it "shows flash error message if user is not logged in" do
      # Act
      get new_product_path
        
      # Assert
      expect(flash[:error]).must_equal "You must be logged in to create a product"
    end

  end

  describe "create" do
    it "can create a new product with valid information accurately, and redirect" do
      perform_login()
      
      # Arrange
      product_hash = {
        product: {
          name: "new product",
          price: 5.55,
          inventory: 5,
          merchant_id: merchants(:merchant_1).id
        },
      }
      
      # Act-Assert
      expect {
        post products_path, params: product_hash
      }.must_change "Product.count", 1
      
      new_product = Product.find_by(name: product_hash[:product][:name])
      expect(new_product.name).must_equal product_hash[:product][:name]
      expect(new_product.price).must_equal product_hash[:product][:price]
      expect(new_product.inventory).must_equal product_hash[:product][:inventory]

      expect(flash[:success]).must_include "has been added to the product database"
      must_redirect_to product_path(new_product.id)
    end

    it "does not create a product if user is not logged in" do
      # Arrange
      product_hash = {
        product: {
          name: "new product",
          price: 5.55,
          inventory: 5,
          category: "a category",
        },
      }
      
      # Act-Assert
      expect {
        post products_path, params: product_hash
      }.must_differ "Product.count", 0
      
      expect(flash[:error]).must_equal "You must be logged in to create a product"
      must_redirect_to root_path
    end

    it "does not create a product if the form data violates product validations, and responds with a redirect" do
      perform_login
      
      product_hash = {
        product: {
          name: nil
        },
      }
      
      # Act-Assert
      expect {
        post products_path, params: product_hash
      }.must_differ "Product.count", 0
            
      must_respond_with :bad_request
    end
  end

  describe "update" do 
    it "will update product" do 
      product_hash = {
        product: {
          name: "changed art",
          price: 100
        }
      }

      product = Product.first
      expect { patch product_path(product.id), params: product_hash
      }.must_differ "Product.count", 0 

      must_redirect_to product_path(product.id)
      expect(product.reload.name).must_equal product_hash[:product][:name]
    end 
  end 

  describe "retire" do
    it "changes active column to false if product belongs to current user" do
      perform_login(merchants(:merchant_1))
      product = products(:product_1)
      
      patch retire_product_path(product.id)

      expect(product.reload.active).must_equal false
      must_redirect_to current_merchant_path
    end

    it "cannot be retired if product does not belong to current user" do
      perform_login
      product = products(:product_4)

      patch retire_product_path(product.id)

      must_redirect_to root_path
      expect(product.reload.active).must_equal true
    end
  end
end
