class Apartment < ApplicationRecord
  belongs_to :user
  validates :street, presence: true
end
