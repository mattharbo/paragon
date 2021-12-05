class ChangeColumnToSelections < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:selections, :substitute_id, true)
  end
end
