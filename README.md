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

## API Endpoints and Validations
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
      expect(apartment.first['street']).to include("can't be blank")
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
    params.require(:apartment).permit(:street, :city, :state, :manager, :email, :price, :bedrooms, :bathrooms, :pets, :image, :user_id)
  end
```
- See it pass 
- $ `rspec spec/requests/apartments_spec.rb`