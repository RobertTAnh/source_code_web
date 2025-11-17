class AddKindToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :kind, :string
  end
end
