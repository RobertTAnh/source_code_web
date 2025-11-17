class AddDescriptionToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :description, :string
  end
end
