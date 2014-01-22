class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :client, index: true
      t.string :name
      t.string :code
      t.boolean :billable, :default => true
      t.decimal :budget
      t.text :notes
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
