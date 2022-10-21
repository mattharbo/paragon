class CreateKits < ActiveRecord::Migration[6.1]
  def change
    create_table :kits do |t|

      t.references :team, null: false, foreign_key: true
      t.references :season, null: false, foreign_key: true
      t.string :home_primary_color
      t.string :home_secondary_color
      t.string :away_primary_color
      t.string :away_secondary_color
      t.string :third_primary_color
      t.string :third_secondary_color

      t.timestamps
    end

  end
end
