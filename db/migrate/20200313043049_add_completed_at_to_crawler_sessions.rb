class AddCompletedAtToCrawlerSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :crawler_sessions, :completed_at, :timestamp
  end
end
