class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :jerseynumber
      t.date :startdate
      t.date :enddate

      t.timestamps
    end
  end
end
