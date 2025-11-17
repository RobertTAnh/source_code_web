class NotifierMailer < ApplicationMailer
  helper Rails.application.routes.url_helpers
  helper RouteHelper

  default :from => "FagoGroup Technologies <techfagogroup@gmail.com>"

  def order_created(data)
    return unless Settings.email_notification_enabled?
    return unless WebConfig.for('notifications.order_received.enabled')

    @data = data

    emails = (default_email_list + order_received_email_list + system_default_email_list).uniq

    return if emails.blank?

    mail :to => emails.join(', '), :subject => "[#{WebConfig.for('website.name')}] Thông báo có khách hàng: #{data.customer_name} đã đặt hàng thành công!"
  end

  def contact_received(data)
    return unless Settings.email_notification_enabled?
    return unless WebConfig.for('notifications.contact_received.enabled')

    @data = data

    emails = (default_email_list + contact_received_email_list + system_default_email_list).uniq

    return if emails.blank?

    mail :to => emails.join(', '), :subject => "[#{WebConfig.for('website.name')}] Thông báo có khách hàng: #{data.name} đăng ký liên hệ"
  end

  def default_email_list
    WebConfig.for('notifications.emails.default_list')&.split(',') || []
  end

  def order_received_email_list
    WebConfig.for('notifications.order_received.emails')&.split(',') || []
  end

  def contact_received_email_list
    WebConfig.for('notifications.contact_received.emails')&.split(',') || []
  end

  def system_default_email_list
    ENV["SYSTEM_DEFAULT_NOTI_EMAILS"]&.split(",") || []
  end

end
