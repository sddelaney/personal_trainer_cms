class AddSessionsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sessions, :integer
  end
end
