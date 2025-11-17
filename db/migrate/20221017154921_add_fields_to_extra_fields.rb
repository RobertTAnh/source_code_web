class AddFieldsToExtraFields < ActiveRecord::Migration[7.0]
  def change
    add_column :extra_fields, :data, :jsonb
    add_column :extra_fields, :data_type, :string

    remove_column :extra_fields, :value, :string
    remove_column :extra_fields, :format, :string
  end
end
