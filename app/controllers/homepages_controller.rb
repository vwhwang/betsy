class HomepagesController < ApplicationController
  def index
    @products = Product.all 
  end 
end
