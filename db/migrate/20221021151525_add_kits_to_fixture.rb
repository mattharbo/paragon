class AddKitsToFixture < ActiveRecord::Migration[6.1]
  def change
    add_column :fixtures, :homekit, :string
    add_column :fixtures, :awaykit, :string
  end
end
