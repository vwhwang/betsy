class CategoriesController < ApplicationController
  
  skip_before_action :require_login, only: [:root, :show]

  # def index
  #   @category = Category.all
  # end 

  def show 
    @category = Category.find_by(id: params[:id])
    if @category.nil? 
      flash[:error] = "Category does not exist"
      head :not_found
      return
    end
    @products = @category.products
  end


  private

  def category_params
    params.require(:category).permit(:name)
  end
  
end
