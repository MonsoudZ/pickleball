class AddPublicationStatusToTrainingSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :training_sessions, :published, :boolean, null: false, default: false
    add_column :training_sessions, :status, :string, null: false, default: "scheduled"

    add_index :training_sessions, [ :published, :status, :starts_at ], name: "index_training_sessions_on_public_schedule"
  end
end
