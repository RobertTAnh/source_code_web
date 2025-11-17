class AddUniversalSlugToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :universal_slug, :string
    add_index :posts, ['universal_slug', 'locale'], unique: true
  end
end
