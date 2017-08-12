class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :survivor, foreign_key: true
      t.integer :item_id
      t.integer :quantity

      t.timestamps
    end
  end
end
