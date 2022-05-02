class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :selection, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.references :eventtype, null: false, foreign_key: true
      t.string :time

      t.timestamps
    end
  end
end
