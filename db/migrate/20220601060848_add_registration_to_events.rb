class AddRegistrationToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :registration, :boolean
  end
end
