class CreateExtraFields < ActiveRecord::Migration[7.0]
  def change
    create_table :extra_fields do |t|
      t.references :owner, polymorphic: true
      t.string :key, null: false
      t.string :value, null: false
      t.string :format

      t.timestamps
    end

    add_index :extra_fields, [:owner_type, :owner_id, :key], unique: true
  end
end
