class AddImageUrlToVariant < ActiveRecord::Migration[7.0]
  def change
    add_column :variants, :image_url, :string
  end
end
