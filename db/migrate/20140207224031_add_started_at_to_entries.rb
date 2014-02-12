class AddStartedAtToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :started_at, :timestamp
  end
end
