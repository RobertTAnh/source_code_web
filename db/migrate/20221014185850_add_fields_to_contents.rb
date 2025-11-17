class AddFieldsToContents < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :seo_index, :boolean, default: true
    add_column :contents, :seo_follow, :boolean, default: true
    add_column :contents, :table_of_content, :text
  end
end
