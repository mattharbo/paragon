class AddDateToFixture < ActiveRecord::Migration[6.1]
  def change
    add_column :fixtures, :date, :date
  end
end
