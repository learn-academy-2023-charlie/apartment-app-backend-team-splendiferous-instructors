# Apartment App Backend
## Overview of Project with Devise and JWT
- References
[Token Based Authentication](https://dzone.com/articles/cookies-vs-tokens-the-definitive-guide)

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
- [Devise](https://rubydoc.info/github/heartcombo/devise): Ruby gem that provide authorization and authenication to an application
- authentication: indentification of a valid user
- authorization: the functionality that a user can perform on an application or data that a user has access to 
- user session: is created to track the status of the user
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

## API Endpoints and Validations
- Reference for API endpoints: https://github.com/learn-academy-2023-charlie/syllabus/blob/main/rails/rails-api.md
### index
- Stub out endpoints in app/controllers/apartments_controller.rb
```rb
  def index
  end
```
- Create request rspec testings
```rb
require 'rails_helper'

RSpec.describe "Apartments", type: :request do
  let(:user) { User.create(
    email: 'test@example.com',
    password: 'password',
    password_confirmation: 'password'
    )
  }

  describe "GET /index" do
    it 'gets a list of apartments' do
      apartment = user.apartments.create(
        street: '124 Conch St',
        unit: 'A',
        city: 'Bikini Bottom',
        state: 'Pacific Ocean',
        square_footage: 2000,
        price: '4000',
        bedrooms: 0,
        bathrooms: 1,
        pets: 'yes',
        image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg'
      )

      get '/apartments'

      apartment = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(apartment.first['street']).to eq('124 Conch St')
    end
  end

  # test for creating a new apartment will live here
end
```
- See it fail
- $ `rspec spec/requests/apartments_spec.rb`
- Modify the endpoint
```rb
  def index
    apartments = Apartment.all
    render json: apartments
  end
```
- See it pass 
- $ `rspec spec/requests/apartments_spec.rb`

### create
- Model
app/models/apartment.rb
spec/models/apartment_spec.rb
```rb
  require 'rails_helper'

  RSpec.describe Apartment, type: :model do

    let(:user) { User.create(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
      )
    }

    it 'should validate street' do
      apartment = user.apartments.create(
        street: nil,
        unit: 'A',
        city: 'Bikini Bottom',
        state: 'Pacific Ocean',
        square_footage: 2000,
        price: '4000',
        bedrooms: 0,
        bathrooms: 1,
        pets: 'yes',
        image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg'
      )
      expect(apartment.errors[:street]).to_not be_empty
    end
  end
```
- See it fail
- $ `rspec spec/models/apartment_spec.rb`
- Modify the model
```rb
  class Apartment < ApplicationRecord
    belongs_to :user
    validates :street, presence: true
  end
```
- See it pass
- $ `rspec spec/models/apartment_spec.rb`

- Endpoint
spec/requests/apartments_spec.rb
- Stub out endpoints in app/controllers/apartments_controller.rb
```rb
  def create
  end
```
- add a test case for the create endpoint  
*** NOTE: these params will include the foreign key that would normally be assigned through rails to reflect the association that the apartment has to the user ***
```rb
  describe "POST /create" do
      it "doesn't create an apartment without a street" do
      # attributes stored in an object to send to my application to have it loaded into the database
      apt_params = {
        apartment: {
          street: nil,
          unit: 'A',
          city: 'Bikini Bottom',
          state: 'Pacific Ocean',
          square_footage: 2000,
          price: '4000',
          bedrooms: 0,
          bathrooms: 1,
          pets: 'yes',
          image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg',
          user_id: user.id
        }
      }

      # make a request to the application to create the object we made
      post '/apartments', params: apt_params

      # The API returns data in the response body. The response body data is structured as JSON. We will parse the response.body 
      apartment = JSON.parse(response.body)

      # assert that the response is correct
        # status code
      expect(response).to have_http_status(200)
        # error message
      expect(apartment['street']).to include("can't be blank")
    end
  end
``` 
- See it fail
- $ `rspec spec/requests/apartments_spec.rb`
- Modify the endpoint
```rb
  def create
    apartment = Apartment.create(apartment_params)
    if apartment.valid?
      render json: apartment
    else
      render json: apartment.errors, status: 422
    end
  end

  private
  def apartment_params
    params.require(:apartment).permit(:street, :unit, :city, :state, :square_footage, :price, :bedrooms, :bathrooms, :pets, :image, :user_id)
  end
```
- See it pass 
- $ `rspec spec/requests/apartments_spec.rb`

- Reference for delete assertion
https://stackoverflow.com/questions/4803469/how-can-i-assert-that-no-route-matches-in-a-rails-integration-test


### testing destroy API endpoint
- Research
```rb
  # https://rollbar.com/blog/handle-exceptions-in-ruby-with-rescue/
  # Because the request will not be correct, it can cause the test to fail and stop before reaching the assertions. We will use a begin/rescue block to handle the exception. The rescue block catches the ActionController::RoutingError exception and prints an error message to the console. 
  begin
  # make a request to the application to delete the apartment without an id params
    delete '/apartments'

  # parse routing error 
  rescue ActionController::RoutingError => error
    p error
  # assertion the error
    expect(error.message).to include "No route matches"
  end   

  # however since their is already a testing block begin and end will not be needed
```