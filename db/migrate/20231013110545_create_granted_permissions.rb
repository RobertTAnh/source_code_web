class CreateGrantedPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :granted_permissions do |t|
      t.references :permission, null: false, foreign_key: true
      t.string :granted_to_type
      t.bigint :granted_to_id
      t.jsonb :conditions

      t.timestamps
    end
  end
end
