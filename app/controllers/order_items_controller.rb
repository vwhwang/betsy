class OrderItemsController < ApplicationController
  def create
  @product = Product.find_by(id: params[:product_id])

  if @product.nil?
    flash[:error] = "Product no longer exists."
    return head :not_found
  end

  if !@product.available?
    flash[:error] = "Stock not available"
    # return head :not_found
  end

  order_item = OrderItem.new(customer_id: customer.id, video_id: video.id)
end

private

def order_item_params
  return params.require(:order_item).permit(:quantity, :order_id, :product_id)
end
end
