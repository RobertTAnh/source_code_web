class CreateWebConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :web_configs do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
