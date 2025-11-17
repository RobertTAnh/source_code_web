class CreateThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :themes do |t|
      t.string :name, null: false
      t.boolean :is_default, default: false
      t.string :source, null: false
      t.string :path

      t.timestamps
    end
  end
end
