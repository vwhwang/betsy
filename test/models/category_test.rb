require "test_helper"

describe Category do
  it "has many products" do 
    category = categories(:category_2)

    puts "*******#{category.products}"

    expect(category.products.length).must_equal 3
  end 
end
