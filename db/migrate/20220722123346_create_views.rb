class CreateViews < ActiveRecord::Migration[7.0]
  def change
    create_table :views do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.references :theme, null: false, foreign_key: true
      t.string :viewable_type
      t.string :view_type
      t.integer :version
      t.string :template_format
      t.text :template
      t.string :path
      t.text :javascript
      t.text :style
      t.jsonb :config
      t.jsonb :data
      t.references :layout, null: true, foreign_key: { to_table: 'views' }

      t.timestamps
    end
  end
end
