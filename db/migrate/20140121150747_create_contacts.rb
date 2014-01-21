class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :client, index: true
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :email
      t.string :phone
      t.string :fax

      t.timestamps
    end
  end
end
