class CreateMoves < ActiveRecord::Migration[6.1]
  def change
    create_table :moves do |t|
      t.references :event, null: false, foreign_key: true
      t.references :movetype, null: false, foreign_key: true
      t.references :selection, null: false, foreign_key: true
      t.string :startxcoord
      t.string :startycoord
      t.string :endxcoord
      t.string :endycoord
      t.integer :rank
      t.boolean :key

      t.timestamps
    end
  end
end
