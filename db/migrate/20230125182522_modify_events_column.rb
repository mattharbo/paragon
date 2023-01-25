class ModifyEventsColumn < ActiveRecord::Migration[6.1]
  def change
    change_column(:events, :distance, :float)
  end
end
