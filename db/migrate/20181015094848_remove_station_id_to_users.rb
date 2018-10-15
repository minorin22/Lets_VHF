class RemoveStationIdToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :station_id, :integer
  end
end
