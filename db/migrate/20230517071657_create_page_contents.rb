class CreatePageContents < ActiveRecord::Migration[7.0]
  def change
    create_table :page_contents do |t|
      t.jsonb :data
      t.references :owner, polymorphic: true, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
