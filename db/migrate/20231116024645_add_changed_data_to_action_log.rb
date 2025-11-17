class AddChangedDataToActionLog < ActiveRecord::Migration[7.0]
  def change
    add_column :action_logs, :changed_data, :jsonb
  end
end
