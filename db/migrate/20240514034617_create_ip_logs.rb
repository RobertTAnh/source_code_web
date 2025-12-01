class CreateIpLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :ip_logs do |t|
      t.string :ip
      t.string :action
      t.boolean :spam

      t.timestamps
    end
  end
end
