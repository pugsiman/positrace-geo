class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_enum :location_status, %i[pending updated]

    create_table :locations do |t|
      t.enum :status, enum_type: :location_status, default: :pending, null: false
      t.string :identifier, index: :unique, null: false
      t.st_point :lonlat
      t.index :lonlat, using: :gist
      t.datetime :refreshed_at

      t.timestamps
    end
  end
end
