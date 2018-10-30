class ChangeDscsColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :dscs, :message_type, :string
    remove_column :dscs, :type, :string
  end
end
