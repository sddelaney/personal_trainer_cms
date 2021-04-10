class AddCredentialsToToken < ActiveRecord::Migration[6.0]
  def change
    add_column :tokens, :Credentials, :text
  end
end
