class AddPrimaryToCategorizations < ActiveRecord::Migration[7.0]
  def change
    add_column :categorizations, :primary, :boolean
  end
end
