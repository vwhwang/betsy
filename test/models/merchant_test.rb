require "test_helper"

describe Merchant do
  describe "validations" do
    it "requires a username" do
      merchant = Merchant.new
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :username
    end

    it "requires a unique username" do
      username = "test username"
      email = "test@gmail.com"
      merchant1 = Merchant.new(username: username, email: email)

      # This must go through, so we use create!
      merchant1.save!

      merchant2 = Merchant.new(username: username)
      result = merchant2.save
      expect(result).must_equal false
      expect(merchant2.errors.messages).must_include :username
    end

    it "requires an email" do
      merchant = Merchant.new
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :email
    end

    it "requires a unique email" do
      username = "test username"
      email = "test@gmail.com"
      merchant1 = Merchant.new(username: username, email: email)

      # This must go through, so we use create!
      merchant1.save!

      merchant2 = Merchant.new(email: email)
      result = merchant2.save
      expect(result).must_equal false
      expect(merchant2.errors.messages).must_include :email
    end
  end

  describe "relationships" do
    it "has a list of products" do
      merchant1 = merchants(:merchant_2)
      expect(merchant1).must_respond_to :products
      merchant1.products.each do |product|
        expect(products).must_be_kind_of product
      end
    end
  end

end
