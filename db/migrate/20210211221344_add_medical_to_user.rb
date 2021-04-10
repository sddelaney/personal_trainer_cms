class AddMedicalToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :medical, :text
  end
end
