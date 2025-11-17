class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.references :owner, polymorphic: true, index: { unique: true }
      t.text :description
      t.text :body
      t.string :image_url
      t.string :meta_title
      t.string :meta_keywords
      t.string :meta_description
      t.string :tracking_head
      t.string :tracking_body
      t.string :tracking_content

      t.timestamps
    end
  end
end
