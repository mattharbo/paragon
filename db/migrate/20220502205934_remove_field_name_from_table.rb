class RemoveFieldNameFromTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :team_id
  end
end
