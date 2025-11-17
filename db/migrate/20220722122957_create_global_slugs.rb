class CreateGlobalSlugs < ActiveRecord::Migration[7.0]
  def change
    create_table :global_slugs do |t|
      t.string :name, null: false
      t.bigint :sluggable_id, null: false
      t.string :sluggable_type, null: false

      t.timestamps
    end

    add_index :global_slugs, :name, unique: true
    add_index :global_slugs, [:name, :sluggable_id, :sluggable_type], unique: true
  end
end
