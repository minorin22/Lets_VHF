class CreateDscs < ActiveRecord::Migration[5.2]
  def change
    create_table :dscs do |t|
      t.integer :from_id
      t.integer :to_id
      t.string :category
      t.string :format
      t.string :type
      t.integer :work_ch
      t.string :reason
      t.string :eos
      t.string :nature
      t.float :lat
      t.float :long
      t.float :utc
      t.integer :dist_id

      t.timestamps
    end
  end
end
