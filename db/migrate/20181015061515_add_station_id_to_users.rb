class AddStationIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :station_id, :integer
  end
end
