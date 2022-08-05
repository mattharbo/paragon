class AddSubmittedToFixtures < ActiveRecord::Migration[6.1]
  def change
    add_column :fixtures, :submitted, :boolean
  end
end
