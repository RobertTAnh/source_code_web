class AddPrimaryToGlobalSlugs < ActiveRecord::Migration[7.0]
  def change
    add_column :global_slugs, :primary, :boolean, default: false
  end
end
