class ChangePlyerapirefType < ActiveRecord::Migration[6.1]
  def change
    change_column :players, :playerapiref, :string
  end
end
