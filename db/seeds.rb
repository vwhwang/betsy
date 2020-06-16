# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



require 'csv'

Merchant.create(username: "vickibot", email:"vicki@bot.com")
Merchant.create(username: "junitobot", email: "junito@bot.com")

puts "Created #{Merchant.count} merchant"

categories = [
  {
    name: "Abstract"
  },
  {
    name: "Realism"
  },  
  {
    name: "Surrealism"
  },  
  {
    name: "Pop Art"
  },  
  {
    name: "Sculpture"
  },  
]

count = 0
categories.each do |category|
  if Category.create(category)
    count += 1
  end
end

puts "Created #{count} categories"

PRODUCT_FILE = Rails.root.join('db','products-seeds3.csv',)


product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true ) do |row|
  categories_sample = []
  categories_sample.push(rand(1..5))
  categories_sample.push(rand(1..5))
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price = row['price']
  product.inventory = row['inventory']
  product.image = row['image']
  product.artist = row['artist']
  product.merchant_id = row['merchant_id']
  product.category_ids = categories_sample
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





