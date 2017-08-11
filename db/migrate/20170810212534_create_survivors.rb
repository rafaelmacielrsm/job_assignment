class CreateSurvivors < ActiveRecord::Migration[5.1]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :longitude
      t.string :latitude
      t.boolean :infected, default: false

      t.timestamps
    end
  end
end
