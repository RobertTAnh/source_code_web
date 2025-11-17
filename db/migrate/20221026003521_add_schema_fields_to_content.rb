class AddSchemaFieldsToContent < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :seo_schema, :jsonb
    add_column :contents, :seo_schema_breadcumb, :jsonb
  end
end
