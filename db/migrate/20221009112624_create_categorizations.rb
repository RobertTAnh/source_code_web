class CreateCategorizations < ActiveRecord::Migration[7.0]
  def change
    create_table :categorizations do |t|
      t.references :category, null: false, foreign_key: true
      t.references :categorizable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :categorizations, [:category_id, :categorizable_id, :categorizable_type], unique: true, name: 'index_categorizations_on_category_id_and_categorizable'
  end
end
