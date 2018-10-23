class AddPowerToStations < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :power, :integer
  end
end
