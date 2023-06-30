# Apartment App Backend
## Overview of Project with Devise and JWT
- References
[Token Based Authentication](https://dzone.com/articles/cookies-vs-tokens-the-definitive-guide)  
[Rails API](https://github.com/learn-academy-2023-charlie/syllabus/blob/main/rails/rails-api.md)

## Process
## GitHub Class Repo
- used as an empty repo to store the API
- One team member setups team name
## API  
Create API to maintain a collection of apartments for the frontend to make requests  
- One team member will create the API and request branch protections
- Follow [Process Notes](https://github.com/learn-academy-2023-charlie/syllabus/blob/main/apartment-app/backend/devise.md) in syllabus
- Provide authentication and authorization using devise and jwt
### Vocab
- [Devise](https://rubydoc.info/github/heartcombo/devise): Ruby gem that provide authorization and authentication to an application
- authentication: identification of a valid user
- authorization: the functionality that a user can perform on an application or data that a user has access to 
- user session: created to track the status of the user
- [JSON Web Token (JWT)](https://blog.logrocket.com/secure-rest-api-jwt-authentication/): provides secure transmission of data that identifies a user
- localStorage: method that gives API calls access to the JWT

### Flow of User Session  
Limitations will be placed on the requests to the API by determining the authentication and authorization of each user. The ruby gem devise will create a user session when a user signs up or logs in. When a user makes a request, the API will response with a JSON web token. This token will be used to verify the authentication of any subsequent requests from the user. When the user logs out, devise ends the user session. The token is then stored in a denylist table and can no longer be used for authentication.  
1. User enters their login credentials.
2. Server verifies the credentials are correct and returns a signed token.
3. This token is stored client-side.
4. Subsequent requests to the server include this token as an additional Authorization header.
5. The server decodes the JWT and if the token is valid processes the request.
6. Once a user logs out, the token is destroyed client-side.

### Format of JSON Web Token(JWT) 
[JWT](https://www.rubydoc.info/gems/devise-jwt/0.11.0) will be automatically created by the devise-jwt gem. JWT consist of three parts separated by dots (.):  
`header.payload.signature`  
- Header: the type of token and signing algorithm
- Payload: claims (statements) about the user
- Signature: combines header and payload with a secret key to ensure token was not changed and that the user is authenticated

### Protection of JWT
Certain measures will be taken to secure these credentials.
- Short expiration time for tokens. If a token is compromised, it will become useless to the hacker. 
- Revocation strategy. Maintain a denylist table of revoked tokens that will not be allowed to make requests to the application.

## Adding devise dependency and User
$ bundle add devise
$ rails generate devise:install
$ rails generate devise User
$ rails db:migrate

## JSON Web Tokens/CORS dependencies
- Add devise-jwt and rack-cors gems to Gemfile
- To bring in required dependencies: $ bundle
- Create CORS file and add the authorization code that will allow other applications to request data and will allow the JWT authorization to get passed
- disable the token on application controller
```js
  class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token
  end
```

## Apartment resource
- User can have many apartments. Apartments will belong to a user.
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

## Additional render steps
- After the initial deployment is complete remove the bundle exec rake db:seed from this set of commands.