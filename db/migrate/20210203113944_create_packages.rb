class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :title
      t.text :description
      t.string :package_type
      t.decimal :price
      t.integer :sessions

      t.timestamps
    end
  end
end
