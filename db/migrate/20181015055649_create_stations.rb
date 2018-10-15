class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.integer :user_id
      t.string :name
      t.string :call_sign
      t.integer :mmsi
      t.float :lat
      t.float :long
      t.string :region
      t.integer :channel

      t.timestamps
    end
  end
end
