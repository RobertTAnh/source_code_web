class LocalizeGlobalSlugs < ActiveRecord::Migration[7.0]
  def change
    add_column :global_slugs, :locale, :string, limit: 2, null: false, default: :vi
    add_index :global_slugs, [:name, :locale], unique: true

    remove_index :global_slugs, :name, name: 'index_global_slugs_on_name', unique: true
  end
end
