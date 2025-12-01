class AddStatusToVariant < ActiveRecord::Migration[7.0]
  def change
    add_column :variants, :status, :string, default: :published
  end
end
