### create API endpoint and validations
- Reference for API endpoints: https://github.com/learn-academy-2023-charlie/syllabus/blob/main/rails/rails-api.md


### Ensure that there are no validation errors with an entry that contains all its required attributes
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

    it 'is valid with all its required attributes' do
      apartment = user.apartments.create(
        street: '120 Squid Row',
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

      # .full_messages returns the full error messages in an array
      expect(apartment.errors.full_messages).to be_empty

      # asserts that the entry is valid
      expect(apartment).to be_valid

      # assertion that the entry is being displayed (read functionality)
      # .find_by finds the first record matching the specified conditions
      expect(Apartment.find_by street: '120 Squid Row').to eq(apartment)
    end
  end
```
- Because no errors are expected, this test will pass but the goal is to ensure that once the validations are created that no errors will appear.
- $ `rspec spec/models/apartment_spec.rb`
- Modify the model
```rb
  class Apartment < ApplicationRecord
    belongs_to :user
    validates :street, :unit, :city, :state, :square_footage, :price, :bedrooms, :bathrooms, :pets, :image, :user_id, presence: true
  end
```
- Ensure the test will still pass
- $ `rspec spec/models/apartment_spec.rb`

### Testing to see that there are validation errors if an attribute is missing
- Models
```rb
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
```
- See it fail if the model is missing the attribute with the validation helper
- $ `rspec spec/models/apartment_spec.rb`
- Modify the model if the model is missing the attribute in the validation
- See it pass
- $ `rspec spec/models/apartment_spec.rb`


### Testing that the create API endpoint will have a successful response if all attributes present
- Requests  
- spec/requests/apartments_spec.rb
- Stub out endpoints in app/controllers/apartments_controller.rb
```rb
  def create
  end
```
- add a test case for the create endpoint  
*** NOTE: these params will include the foreign key that would normally be assigned through rails to reflect the association that the apartment has to the user ***
```rb
  describe "POST /create" do

    # creates as expected
    it "creates an apartment with all its attributes" do
      # attributes stored in an object to send to my application to have it loaded into the database
      apt_params = {
        apartment: {
          street: '120 Squid Row',
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
        
        # expected one apartment to be created
      apartments = Apartment.all
      expect(apartments.length).to be(1)
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


### Testing that the create API endpoint will respond with an error if missing an attribute
- Requests  
- spec/requests/apartments_spec.rb

- add a test case for the create endpoint  
*** NOTE: these params will include the foreign key that would normally be assigned through rails to reflect the association that the apartment has to the user ***
```rb
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
``` 
- See it pass if functionality setup as indicated on previous tests
- $ `rspec spec/requests/apartments_spec.rb`