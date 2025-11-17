class UpdateUniqWithDiscards < ActiveRecord::Migration[7.0]
  def up
    remove_index :orders, [:code], unique: true
    add_index :orders, [:code], unique: true, where: '(discarded_at IS NULL)'

    remove_index :products, [:sku, :locale], unique: true
    add_index :products, [:sku, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :products, [:slug, :locale], unique: true
    add_index :products, [:slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :products, [:universal_slug, :locale], unique: true
    add_index :products, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :posts, [:slug, :locale], unique: true
    add_index :posts, [:slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :posts, [:universal_slug, :locale], unique: true
    add_index :posts, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :pages, [:slug, :locale], unique: true
    add_index :pages, [:slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :pages, [:universal_slug, :locale], unique: true
    add_index :pages, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :resources, [:universal_slug, :locale], unique: true
    add_index :resources, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :categories, [:slug, :locale], unique: true
    add_index :categories, [:slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :categories, [:universal_slug, :locale], unique: true
    add_index :categories, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'

    remove_index :global_slugs, [:name, :sluggable_id, :sluggable_type], unique: true, where: '(discarded_at IS NULL)'

    remove_index :global_slugs, [:name, :locale], unique: true
    add_index :global_slugs, [:name, :locale], unique: true, where: '(discarded_at IS NULL)'
  end

  def down
    remove_index :orders, [:code], unique: true, where: '(discarded_at IS NULL)'
    add_index :orders, [:code], unique: true

    remove_index :products, [:slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :products, [:slug, :locale], unique: true

    remove_index :products, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :products, [:universal_slug, :locale], unique: true

    remove_index :posts, [:slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :posts, [:slug, :locale], unique: true

    remove_index :posts, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :posts, [:universal_slug, :locale], unique: true

    remove_index :pages, [:slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :pages, [:slug, :locale], unique: true

    remove_index :pages, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :pages, [:universal_slug, :locale], unique: true

    remove_index :resources, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :resources, [:universal_slug, :locale], unique: true

    remove_index :categories, [:slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :categories, [:slug, :locale], unique: true

    remove_index :categories, [:universal_slug, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :categories, [:universal_slug, :locale], unique: true

    add_index :global_slugs, [:name, :sluggable_id, :sluggable_type], unique: true, where: '(discarded_at IS NULL)'

    remove_index :global_slugs, [:name, :locale], unique: true, where: '(discarded_at IS NULL)'
    add_index :global_slugs, [:name, :locale], unique: true
  end
end
