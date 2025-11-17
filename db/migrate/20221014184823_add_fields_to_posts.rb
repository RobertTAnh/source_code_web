class AddFieldsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :description, :string
    add_column :posts, :image_url, :string
    add_column :posts, :status, :string
  end
end
