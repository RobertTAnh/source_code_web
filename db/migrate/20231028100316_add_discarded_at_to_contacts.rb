class AddDiscardedAtToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :discarded_at, :datetime
    add_index :contacts, :discarded_at
  end
end
