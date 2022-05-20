class AddGridposToSelections < ActiveRecord::Migration[6.1]
  def change
    add_column :selections, :grid_pos, :string
  end
end
