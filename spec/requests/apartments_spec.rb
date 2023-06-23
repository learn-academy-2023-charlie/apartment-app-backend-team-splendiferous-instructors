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

      apartment = Apartment.first
      
      expect(response).to have_http_status(200)
      expect(apartment['street']).to eq('124 Conch St')
    end
  end

  describe "POST /create" do

    # creates as expected
    it "creates an apartment with all its attributes" do
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

      post '/apartments', params: apt_params

      apartments = Apartment.all
      apartment = JSON.parse(response.body)

      expect(response).to have_http_status(200)

      expect(apartments.length).to be(1)
    end

    # error if missing an attribute
    it "doesn't create an apartment without a street" do
      
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

      post '/apartments', params: apt_params

      apartment = JSON.parse(response.body)

      expect(response).to have_http_status(422)

      expect(apartment['street']).to include("can't be blank")
    end
  end

  describe "PATCH /update" do

    it "updates an apartment with valid attributes" do
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
          street: '58 Conch Ave',
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

      apartment = JSON.parse(response.body)

      # assert that the response is correct

      expect(response).to have_http_status(200)

      expect(apartment['street']).to eq('58 Conch Ave')
    end

    # missing attributes
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
          unit: 'B',
          city: 'Bikini Bottom',
          state: 'Pacific Ocean',
          square_footage: 2000,
          price: '4500',
          bedrooms: 1,
          bathrooms: 1,
          pets: 'yes',
          image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg',
          user_id: user.id
        }
      }

      # make a request to the application to update the attributes
      patch "/apartments/#{apt.id}", params: apt_params

      apartment = JSON.parse(response.body)

      # assert that the response is correct
        # status code
      expect(response).to have_http_status(422)
        # error message
      expect(apartment['street']).to include("can't be blank")
    end
  end


  describe "DELETE /destroy" do
    it "delete an apartment with a valid id params" do
      # save an apartment 
      apartment1 = user.apartments.create(
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

      apartment2 = user.apartments.create(
        street: '58 Conch St',
        unit: 'A',
        city: 'Bikini Bottom',
        state: 'Pacific Ocean',
        square_footage: 2000,
        price: '4500',
        bedrooms: 1,
        bathrooms: 1,
        pets: 'yes',
        image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg'
      )
      get '/apartments'

      expect(Apartment.count).to eq(2)

      apt = Apartment.first

      delete "/apartments/#{apt.id}"

      # status code
      expect(response).to have_http_status(410)

      expect(Apartment.count).to eq(1)
    end
  end


end