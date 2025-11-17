class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :form
      t.string :name
      t.string :phone
      t.string :email
      t.text :note
      t.jsonb :extra

      t.timestamps
    end
  end
end
