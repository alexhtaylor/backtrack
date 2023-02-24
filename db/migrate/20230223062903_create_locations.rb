class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.datetime :datetime
      t.float :latitude
      t.float :longitude
      t.boolean :current_location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
