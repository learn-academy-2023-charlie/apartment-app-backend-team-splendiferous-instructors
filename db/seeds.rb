# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user1 = User.where(email: "test1@example.com").first_or_create(password: "password", password_confirmation: "password")
user2 = User.where(email: "test2@example.com").first_or_create(password: "password", password_confirmation: "password")

hi_apartments = [
  {
    street: '123 Road',
    unit: '4C', 
    city: 'San Diego', 
    state: 'HI',
    square_footage: 1200,
    price: '$5,000',
    bedrooms:1,
    bathrooms:1.5, 
    pets:'no',
    image: 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YnVuZ2Fsb3d8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60'
  },{
    street: '123 Road',
    unit: '4D', 
    city: 'San Diego', 
    state: 'HI',
    square_footage: 200,
    price: '$5,000',
    bedrooms:1,
    bathrooms:0, 
    pets:'yes',
    image: 'https://images.unsplash.com/photo-1602002418209-55d7a55adf42?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGJ1bmdhbG93fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60'
  }
]

co_apartments = [
  {
    street: '456 Ave',
    unit: '2C', 
    city: 'Fort Collins', 
    state: 'CO',
    square_footage: 1200,
    price: '$1,500',
    bedrooms:2,
    bathrooms:2, 
    pets:'yes',
    image: 'https://images.unsplash.com/photo-1540468348633-084ed9d348f1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGJ1bmdhbG93fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60'
  }
]

hi_apartments.each do |apartment|
  user1.apartments.create(apartment)
  p "creating: #{apartment}"
end

co_apartments.each do |apartment|
  user2.apartments.create(apartment)
  p "creating: #{apartment}"
end