class AddFileUrlToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :file_url, :string
  end
end
