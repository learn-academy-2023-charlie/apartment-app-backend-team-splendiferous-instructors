class CreateApartments < ActiveRecord::Migration[7.0]
  def change
    create_table :apartments do |t|
      t.string :street
      t.string :unit
      t.string :city
      t.string :state
      t.integer :square_footage
      t.string :price
      t.integer :bedrooms
      t.float :bathrooms
      t.string :pets
      t.text :image
      t.integer :user_id

      t.timestamps
    end
  end
end
