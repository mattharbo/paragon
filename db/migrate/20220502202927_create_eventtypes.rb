class CreateEventtypes < ActiveRecord::Migration[6.1]
  def change
    create_table :eventtypes do |t|
      t.string :description

      t.timestamps
    end
  end
end
