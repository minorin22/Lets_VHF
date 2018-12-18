class AddOriginalIdToDscs < ActiveRecord::Migration[5.2]
  def change
    add_column :dscs, :original_id, :integer
  end
end
