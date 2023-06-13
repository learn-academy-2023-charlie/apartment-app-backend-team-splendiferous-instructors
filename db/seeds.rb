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
    image: 'not@apartment.com'
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
    image: 'not@apartment.com'
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
    image: 'not@apartment.com'
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