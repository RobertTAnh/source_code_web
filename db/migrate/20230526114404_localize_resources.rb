class LocalizeResources < ActiveRecord::Migration[7.0]
  def change
    add_column :resources, :locale, :string, limit: 2, null: false, default: :vi
  end
end
