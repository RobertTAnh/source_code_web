class AddDiscardedAtToGlobalSlugs < ActiveRecord::Migration[7.0]
  def up
    add_column :global_slugs, :discarded_at, :datetime
    add_index :global_slugs, :discarded_at
    remove_index :global_slugs, [:name, :sluggable_id, :sluggable_type], unique: true

    add_index :global_slugs, [:name, :sluggable_id, :sluggable_type], unique: true, where: '(discarded_at IS NULL)'
  end

  def down
    remove_index :global_slugs, [:name, :sluggable_id, :sluggable_type], unique: true, where: '(discarded_at IS NULL)'
    remove_index :global_slugs, :discarded_at
    remove_column :global_slugs, :discarded_at, :datetime

    add_index :global_slugs, [:name, :sluggable_id, :sluggable_type], unique: true
  end
end
