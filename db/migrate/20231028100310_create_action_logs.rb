class CreateActionLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :action_logs do |t|
      t.string :state
      t.string :code
      t.jsonb :action_data
      t.jsonb :object_before
      t.bigint :actor_id
      t.string :actionable_type
      t.bigint :actionable_id
      t.jsonb :error

      t.timestamps
    end
  end
end
