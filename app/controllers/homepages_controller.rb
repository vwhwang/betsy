class HomepagesController < ApplicationController
  
  skip_before_action :require_login, only: [:root, :index]
  
  def index
    @products = Product.all 
    @merchants = Merchant.all
    @categories = Category.all
  end 

  
end
