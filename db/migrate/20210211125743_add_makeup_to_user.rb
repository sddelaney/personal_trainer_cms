class AddMakeupToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :makeup, :date
  end
end
