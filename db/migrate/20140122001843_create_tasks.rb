class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.decimal :hourly_rate, precision: 8, scale: 2
      t.boolean :billable
      t.boolean :common

      t.timestamps
    end
  end
end
