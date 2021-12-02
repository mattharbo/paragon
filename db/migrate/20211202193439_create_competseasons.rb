class CreateCompetseasons < ActiveRecord::Migration[6.1]
  def change
    create_table :competseasons do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :season, null: false, foreign_key: true

      t.timestamps
    end
  end
end
