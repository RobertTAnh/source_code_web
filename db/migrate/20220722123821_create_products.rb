class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.references :view, null: true, foreign_key: true

      t.timestamps
    end

    add_index :products, :slug, unique: true
  end
end
