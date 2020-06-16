class CategoriesController < ApplicationController
  def index
    @category = Category.new
  end 

  def show 
    @category = Category.find_by(id: params[:id])
    if @category.nil? 
      flash[:error] = "Category does not exist"
      redirect_to(:back)
      return
    end
    # @products = Products.where(category_ids: category)
    @products = @category.products
  end


  private

  def category_params
    params.require(:category).permit(:name)
  end
  
end
