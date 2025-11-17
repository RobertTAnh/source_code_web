class AddCustomContentToContents < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :custom_content, :jsonb
  end
end
