class AddPublishedAtToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :published_at, :datetime
    add_index :products, :published_at
  end
end