# Apartment App Backend

## Vocab
- Devise: Ruby gem that provide authorization and authenication to an application
- authentication: indentification of a valid user
- authorization: the functionality that a user can perform on an application or data that a user has access to 
- user session: is created to track the status of the user

JSON Web Token
localStorage

## Adding devise dependency
$ bundle add devise
$ rails generate devise:install
$ rails generate devise User
$ rails db:migrate

## JSON Web Tokens/CORS
- Add gems
- Create CORS file and add the authorization code

## Apartment resource
- Use can have many apartments. Apartments will belong to a user.
- $ rails g resource Apartment street:string unit:string city:string state:string square_footage:integer price:string bedrooms:integer bathrooms:float pets:string image:text user_id:integer
- $ rails routes -E

## Seeds

## Devise Configuration

## Devise Controllers