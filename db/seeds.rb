require 'faker'

# initial
puts "initialize..."
Category.destroy_all
Product.destroy_all

[1, 2, 3, 4, 5].each do |n|
  current_category = Category.create!({ name: Faker::Lorem.sentence(word_count: 3) })
  
  3.times { 
    Product.create!(
      name: Faker::Camera.brand_with_model,
      qty: rand(1..10),
      category_id: current_category.id
    ) unless current_category.nil? 
  }
end

puts "Category is #{Category.count} "
puts "Product is #{Product.count} "