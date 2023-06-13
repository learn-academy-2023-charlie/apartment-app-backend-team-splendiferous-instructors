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
      p apartment
      expect(response).to have_http_status(200)
      expect(apartment.first['street']).to eq('124 Conch St')
    end
  end

end
