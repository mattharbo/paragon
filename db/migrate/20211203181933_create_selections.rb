class CreateSelections < ActiveRecord::Migration[6.1]
  def change
    create_table :selections do |t|
      t.references :contract, null: false, foreign_key: true
      t.references :fixture, null: false, foreign_key: true
      t.boolean :starter
      t.integer :substitutiontime
      t.integer :note

      t.timestamps
    end
  end
end
