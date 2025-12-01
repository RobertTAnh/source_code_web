class AddProtectedToRole < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :protected, :boolean
  end
end
