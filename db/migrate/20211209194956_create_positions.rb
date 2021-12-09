class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.string :family

      t.timestamps
    end
  end
end
