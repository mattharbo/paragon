class AddPlayerapirefToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :playerapiref, :integer
  end
end
