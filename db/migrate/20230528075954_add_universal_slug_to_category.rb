class AddUniversalSlugToCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :universal_slug, :string
    add_index :categories, ['universal_slug', 'locale'], unique: true
  end
end
