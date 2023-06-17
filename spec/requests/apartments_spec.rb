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
      expect(response).to have_http_status(422)
        # error message
      expect(apartment['street']).to include("can't be blank")
    end
  end

  describe "PATCH /update" do
    it "doesn't update an apartment without a street" do
      # save an apartment 
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

      apt = Apartment.first
      # modify the existing apartment
      apt_params = {
        apartment: {
          street: nil,
          unit: 'A',
          city: 'Bikini Bottom',
          state: 'Pacific Ocean',
          square_footage: 2000,
          price: '4000',
          bedrooms: 1,
          bathrooms: 1,
          pets: 'yes',
          image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg',
          user_id: user.id
        }
      }

      # make a request to the application to update the attributes
      patch "/apartments/#{apt.id}", params: apt_params

      # The API returns data in the response body. The response body data is structured as JSON. We will parse the response.body 
      apartment = JSON.parse(response.body)

      # assert that the response is correct
        # status code
      expect(response).to have_http_status(422)
        # error message
      expect(apartment['street']).to include("can't be blank")
    end
  end

  describe "DELETE /destroy" do
    it "doesn't delete an apartment without an id params" do
      # save an apartment 
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

      apt = Apartment.first
      
      # make a request to the application to delete the apartment without an id params
      delete '/apartments'

      # parse routing error 
      rescue ActionController::RoutingError => error
      # assertion the error
      expect(error.message).to include "No route matches"

      # The API returns data in the response body. The response body data is structured as JSON. We will parse the response.body 
      message = JSON.parse(response.body)
      # assert that the response is correct because the apartment was not destroyed
        # status code
      expect(response).to have_http_status(200)
        # error message
      expect(apartment['street']).to include('124 Conch St')
    end
  end


end
