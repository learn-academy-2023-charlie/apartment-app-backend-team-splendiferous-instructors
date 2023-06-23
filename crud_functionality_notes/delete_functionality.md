### destroy API endpoint and validations
- Reference for API endpoints: https://github.com/learn-academy-2023-charlie/syllabus/blob/main/rails/rails-api.md

### Ensure that there are no validation errors with a deleted entry 

- Models
``` rb
  it 'is valid if existing apartment is destroyed' do
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
    expect(Apartment.count).to eq(1)
    apartment.destroy
    expect(Apartment.count).to eq(0)
    expect(apartment.errors.full_messages).to be_empty
  end
```

### test that an apartment can be deleted with the proper id params
- Requests
```rb
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
      
      p 'apt before delete', apt

      p response

      delete "/apartments/#{apt.id}"

      apt = JSON.parse(response.body)

      p 'apt after delete', apt

      p response

      # status code
      expect(response).to have_http_status(410)

      expect(Apartment.count).to eq(1)
    end
  end
```


<!-- ### Stretch testing
- Research
```rb
  # Reference for delete assertion  
  https://stackoverflow.com/questions/4803469/how-can-i-assert-that-no-route-matches-in-a-rails-integration-test
  # https://rollbar.com/blog/handle-exceptions-in-ruby-with-rescue/
  # make a request to the application to delete an apartment without an id params
  # Because the request will not be correct, it can cause the test to fail and stop before reaching the assertions. We will use a begin/rescue block to handle the exception. The rescue block catches the ActionController::RoutingError exception and prints an error message to the console. 
  begin
  # make a request to the application to delete the apartment without an id params
    delete '/apartments'

  # parse routing error 
  rescue ActionController::RoutingError => error
    p error

    delete '/apartments/6'

  # assertion the error
    expect(error.message).to include "No route matches"
  end   

  # however since their is already a testing block begin and end will not be needed
```
```rb
    delete '/apartments'

    # catch the ActionController::RoutingError exception
    rescue ActionController::RoutingError => error

    # assertion on the error message
    expect(error.message).to include "No route matches"

    # assert that the response is correct because the apartment was not destroyed
      # status code
    expect(response).to have_http_status(200)
      # error message
    expect(apt['street']).to include('124 Conch St')
``` -->