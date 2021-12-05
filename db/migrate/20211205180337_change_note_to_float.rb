class ChangeNoteToFloat < ActiveRecord::Migration[6.1]
  def change
    change_column :selections, :note, :float
  end
end
