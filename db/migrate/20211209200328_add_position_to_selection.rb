class AddPositionToSelection < ActiveRecord::Migration[6.1]
  def change
    add_reference :selections, :position, foreign_key: true
  end
end
