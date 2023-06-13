# Apartment App Backend
## GitHub Class Repo
- used as an empty repo to store the API
- One team member setups team name
## API
- One team member will create the API and request branch protections
- Follow [Process Notes](https://github.com/learn-academy-2023-charlie/syllabus/blob/main/apartment-app/backend/devise.md) in syllabus

## Vocab
- Devise: Ruby gem that provide authorization and authenication to an application
- authentication: indentification of a valid user
- authorization: the functionality that a user can perform on an application or data that a user has access to 
- user session: is created to track the status of the user

JSON Web Token (JWT): provides secure transmission of data that identifies a user
localStorage: method that gives API calls access to the JWT

## Adding devise dependency and User
$ bundle add devise
$ rails generate devise:install
$ rails generate devise User
$ rails db:migrate

## JSON Web Tokens/CORS dependencies
- Add devise-jwt and rack-cors gems to Gemfile
- To bring in required dependencies: $ bundle
- Create CORS file and add the authorization code that will allow other applications to request data and will allow the JWT authorization to get passed

## Apartment resource
- Use can have many apartments. Apartments will belong to a user.
- $ rails g resource Apartment street:string unit:string city:string state:string square_footage:integer price:string bedrooms:integer bathrooms:float pets:string image:text user_id:integer
- Establish the associations
- Update schema: $ rails db:migrate
- To see available routes: $ rails routes -E
- To see the active records: $ rails c

## Seeds
- Create user
- Create a list of apartment attributes
- Create apartments using .each()

## Devise default configuration
- establish the port
- tell it to listen for get method on the log out
- set navigational format to empty    

## Devise Controllers/Routes
Since JWT are created when a user is authorized during sign in/sign up and revoked when a user is sign out, we will modify the devise controllers and routes associated with that authorization.
### Devise Controllers
- $ rails g devise:controllers users -c registrations sessions
- Replace content to respond to json appropriately on each controller
### Devise Routes
- establish alias for each route to reflect the appropriate controller and url for that applicable user session

## JWT Secret Key
- Generate a secret key
- Store key in the credentials file
- Ensure master.key is reflected in the .gitignore file

## Devise JWT Configuration
- Define the type of requests that will use JWT

## DenyList Revocation Strategy
- generate a table that will stored the JWT that are revoked when a user logs out
- modify the migration to reflect the proper tracking of JWT
- update the schema
- modify the User model to reflect the revocation strategy