# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



require 'csv'

PRODUCT_FILE = Rails.root.join('db','products-seeds3.csv',)

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true ) do |row|
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price = row['price']
  product.inventory = row['inventory']
  product.image = row['image']
  product.artist = row['artist']
  product.merchant_id = row['merchant_id']
  successful = product.save

  if !successful
    product_failures << product 
    puts "Failed to save product: #{product.inspect}"
  else   
    puts "Created product: #{product.inspect}"
  end 
  
end 

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"