class Order < ApplicationRecord
  has_many :order_items

  # create_table "orders", force: :cascade do |t|
  #   t.string "name"
  #   t.string "email"
  #   t.string "address"
  #   t.integer "credit_card"
  #   t.date "credit_card_exp"
  #   t.datetime "created_at", precision: 6, null: false
  #   t.datetime "updated_at", precision: 6, null: false
  # end


  #   add state to order model 

  # Purchasing an order makes the following changes:
  #   Reduces the number of inventory for each product 
  #   Changes the order state from "pending" to "paid"
  
  #   Clears the current cart









  

end
