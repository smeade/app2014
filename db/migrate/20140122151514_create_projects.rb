class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :client, index: true
      t.string :name
      t.string :code
      t.boolean :billable
      t.decimal :budget
      t.text :notes

      t.timestamps
    end
  end
end
