require "test_helper"

describe CategoriesController do
  it "responds with success" do 
    @category = categories(:category_1)
    get "/categories/#{@category.id}"

    must_respond_with :success 

  end 

  # it "can get all Categories" do 
    
  #   get "/categories"

  #   must_respond_with :success 

  # end 

  it "gives an error if incorrect category passed in" do 

    @category = categories(:category_1)
    @category.id = -1
    get "/categories/#{@category.id}"

    expect(flash[:error]).must_include "Category does not exist"
    must_respond_with :not_found 
  end 

end
