class RenameUserSessionsToTrainingSessions < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :sessions, :training_sessions
  end
end
