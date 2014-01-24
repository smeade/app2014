class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.date :date
      t.integer :minutes
      t.references :project, index: true
      t.text :description
      t.text :journal
      t.boolean :billable, :default => true

      t.timestamps
    end
  end
end
