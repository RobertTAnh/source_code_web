class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.string :name, null: false
      t.string :slug, unique: true, index: true
      t.bigint  :owner_id, null: true
      t.string  :owner_type, null: true

      t.timestamps
    end
  end
end
