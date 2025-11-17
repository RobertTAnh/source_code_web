class AddDiscardedAtToResources < ActiveRecord::Migration[7.0]
  def change
    add_column :resources, :discarded_at, :datetime
    add_index :resources, :discarded_at
  end
end
