class AddFormationToFixture < ActiveRecord::Migration[6.1]
  def change
    add_column :fixtures, :homeformation, :string
    add_column :fixtures, :awayformation, :string
  end
end
