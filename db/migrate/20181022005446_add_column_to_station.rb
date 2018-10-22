class AddColumnToStation < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :state, :integer
    add_column :stations, :tmp_ch, :integer
  end
end
