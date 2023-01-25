class AddColumnsToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :xpitchcoord, :integer
    add_column :events, :ypitchcoord, :integer
    add_column :events, :xcagecoord, :integer
    add_column :events, :ycagecoord, :integer
    add_column :events, :distance, :integer
    add_column :events, :goalrank, :integer
  end
end
