class CreateMovetypes < ActiveRecord::Migration[6.1]
  def change
    create_table :movetypes do |t|
      t.string :description

      t.timestamps
    end
  end
end
