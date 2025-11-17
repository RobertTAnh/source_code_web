class AddDiscardedAtToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :discarded_at, :datetime
    add_index :albums, :discarded_at
  end
end
