class AddSubstituteToSelections < ActiveRecord::Migration[6.1]
  def change
    add_reference :selections, :substitute, null: false, foreign_key: { to_table: :players }
  end
end
