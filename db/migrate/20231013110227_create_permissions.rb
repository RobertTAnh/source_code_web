class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :granted_on
      t.text :description

      t.timestamps
    end
  end
end
