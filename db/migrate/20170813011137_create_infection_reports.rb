class CreateInfectionReports < ActiveRecord::Migration[5.1]
  def change
    create_table :infection_reports do |t|
      t.references :survivor, foreign_key: true, on_delete: :cascade
      t.references :infected, foreign_key: {to_table: :survivors}, on_delete: :cascade
      t.timestamps
    end
    add_index(:infection_reports, ["survivor_id", "infected_id"], unique: true)
    # add_index(:infection_reports, :infected_id)
    # add_foreign_key(:infection_reports, :survivor, column: :infected_id)
  end
end
