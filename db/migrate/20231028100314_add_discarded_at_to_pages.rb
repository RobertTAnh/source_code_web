class AddDiscardedAtToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :discarded_at, :datetime
    add_index :pages, :discarded_at
  end
end
