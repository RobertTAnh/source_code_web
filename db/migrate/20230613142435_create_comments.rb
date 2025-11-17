class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string  :name
      t.string  :user_uuid, null: true
      t.boolean :is_admin, null: false, default: false
      t.string  :phone, null: true
      t.string  :email, null: true
      t.string  :address, null: true
      t.text    :content, null: false
      t.integer :depth, null: false, default: 0
      t.integer :rate, null: true
      t.string  :status, null: false
      t.bigint  :owner_id, null: true
      t.string  :owner_type, null: true

      t.references :user, null: true, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :comments } 

      t.timestamps
    end
  end
end
