class Apartment < ApplicationRecord
  belongs_to :user
  validates :street, :unit, :city, :state, :square_footage, :price, :bedrooms, :bathrooms, :pets, :image, :user_id, presence: true
end
