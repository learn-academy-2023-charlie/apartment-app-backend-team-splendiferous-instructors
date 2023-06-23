### index API endpoint and validations
- Reference for API endpoints: https://github.com/learn-academy-2023-charlie/syllabus/blob/main/rails/rails-api.md

- https://dev.to/ionabrabender/testing-crud-with-rspec-and-rails-186k

### Testing to see that an entry can be read
- will be covered by asserting on the test for the create functionality


### Testing to see that the API endpoint will response with all the database entries with a correct request  

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

        # make a request to see all the apartments
        get '/apartments'

        # since the response will show an array of all the entries, use active record query to contain the first entry in the array
        apartment = Apartment.first
      
        # assert the successful status code
        expect(response).to have_http_status(200)
        # assert the value of an attribute
        expect(apartment['street']).to eq('124 Conch St')
      end
    end
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

