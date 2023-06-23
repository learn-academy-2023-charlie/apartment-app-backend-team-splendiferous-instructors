require 'rails_helper'

RSpec.describe Apartment, type: :model do
  let(:user) { User.create(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
      )
    }

  # all attributes present
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

    expect(apartment.errors.full_messages).to be_empty

    expect(apartment).to be_valid

    expect(Apartment.find_by street: '120 Squid Row').to eq(apartment)
  end

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
    expect(apartment[:street]).to eq('120 Squid Row')
  end

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
end
