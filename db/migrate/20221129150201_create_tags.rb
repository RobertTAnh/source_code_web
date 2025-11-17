class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.bigint  :owner_id, null: false
      t.string  :owner_type, null: false

      t.timestamps
    end

    add_index :tags, [:name, :owner_id, :owner_type], unique: true
  end
end
