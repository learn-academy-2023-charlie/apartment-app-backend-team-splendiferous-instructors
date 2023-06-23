### update API endpoint and validations
- Reference for API endpoints: https://github.com/learn-academy-2023-charlie/syllabus/blob/main/rails/rails-api.md


### Ensure that there are no validation errors with an updated entry that contains all its required attributes 

- Models
```rb
  it 'is a valid update with all its required attributes' do
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

    apartment.update(
      street: '120 Squid Row',
      unit: 'A',
      city: 'Swim Trunk',
      state: 'Pacific Ocean',
      square_footage: 2000,
      price: '4000',
      bedrooms: 2,
      bathrooms: 1,
      pets: 'no',
      image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg'
    )

    # asserts that the entry is valid
    expect(apartment).to be_valid

    # assertion that attribute was updated
    expect(apartment[:city]).to eq('Swim Trunk')
  end
```

### Ensure that there are validation errors with an updated entry that are missing required attributes 
- Models
```rb
  it 'should validate apartment cannot be updated if missing street' do
    apartment = user.apartments.create(
      street: '120 Sponge Rd',
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

    apartment.update(
      street: nil,
      unit: 'A',
      city: 'Swim Trunk',
      state: 'Pacific Ocean',
      square_footage: 2000,
      price: '4000',
      bedrooms: 2,
      bathrooms: 1,
      pets: 'no',
      image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg'
    )

    expect(apartment).to_not be_valid

    expect(apartment.errors[:street]).to_not be_empty
  end
```

### Ensure that there are successful responses with a valid update 
- requests
```rb
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

      # The API returns data in the response body. The response body data is structured as JSON. We will parse the response.body 
      apartment = JSON.parse(response.body)

      # assert that the response is correct
        # status code
      expect(response).to have_http_status(200)
        # error message
      expect(apartment['street']).to include('58 Conch Ave')
    end
  end
```

### Ensure that there are error responses with an invalid update 
- requests
```rb
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
          city: 'Flip Flop',
          state: 'Atlantic Ocean',
          square_footage: 2000,
          price: '4000',
          bedrooms: 0,
          bathrooms: 1,
          pets: 'yes',
          image: 'https://upload.wikimedia.org/wikinews/en/0/00/FanExpo_Canada_crowd_IMG_6145.jpg'
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
```