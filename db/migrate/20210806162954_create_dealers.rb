class CreateDealers < ActiveRecord::Migration[6.1]
  def change
    create_table :dealers do |t|
      t.string :name, unique: true
      t.string :phone
      t.string :street
      t.string :city
      t.string :country
      t.string :zipcode
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
