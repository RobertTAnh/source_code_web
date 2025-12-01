class MigrateDefaultMailList < ActiveRecord::Migration[7.0]
  def change
    mail_list = ENV["SYSTEM_DEFAULT_NOTI_EMAILS"]&.split(",") || []
    mail_list.concat(WebConfig.for('notifications.emails.default_list')&.split(",") || [])
    WebConfig.current&.add_string('notifications.emails.default_list', mail_list.uniq.join(','))
  end
end
