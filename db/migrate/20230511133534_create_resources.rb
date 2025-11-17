class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources do |t|
      t.string :type, null: false
      t.string :slug
      t.string :name, null: false
      t.bigint :view_id
      t.string :image_url
      t.string :status
      t.string :description
      t.jsonb :properties

      t.timestamps
    end
  end
end
