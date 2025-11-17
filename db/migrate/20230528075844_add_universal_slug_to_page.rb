class AddUniversalSlugToPage < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :universal_slug, :string
    add_index :pages, ['universal_slug', 'locale'], unique: true
  end
end
