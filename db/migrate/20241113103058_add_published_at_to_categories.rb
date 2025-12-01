class AddPublishedAtToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :published_at, :datetime
    add_index :categories, :published_at
  end
end