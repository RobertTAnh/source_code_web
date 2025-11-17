class AddFieldsToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :description, :string
    add_column :categories, :status, :string
    add_column :categories, :image_url, :string
  end
end
