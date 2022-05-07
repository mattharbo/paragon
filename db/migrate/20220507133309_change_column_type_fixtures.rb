class ChangeColumnTypeFixtures < ActiveRecord::Migration[6.1]
  def change
    change_column :fixtures, :round, :string
  end
end
