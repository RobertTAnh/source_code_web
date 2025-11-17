class AddMetaImageToContents < ActiveRecord::Migration[7.0]
  def change
    add_column :contents, :meta_image_url, :string
  end
end
