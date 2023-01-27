class ModifyEventsColumns < ActiveRecord::Migration[6.1]
  def change
    change_column(:events, :xpitchcoord, :string)
    change_column(:events, :ypitchcoord, :string)
    change_column(:events, :xcagecoord, :string)
    change_column(:events, :ycagecoord, :string)
  end
end
