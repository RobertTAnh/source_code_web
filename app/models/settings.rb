class Settings
  class << self
    def page_caching_enabled?
      Rails.env.production? && ENV['PAGE_CACHING_ENABLED'].present?
    end

    def action_caching_enabled?
      Rails.env.production? && ENV['ACTION_CACHING_DISABLED'].blank?
    end

    # Should also update in config/environments/production.rb
    def page_caching_directory
      Rails.root.join(ENV.fetch('PAGE_CACHING_PATH', 'public/cached_pages'))
    end

    def page_caching_scheduled_remove?
      ENV['PAGE_CACHING_SCHEDULED_REMOVE'].present?
    end

    def action_caching_key
      ENV.fetch('ACTION_CACHING_KEY', '/actioncache')
    end

    def action_caching_scheduled_remove?
      ENV['ACTION_CACHING_SCHEDULED_REMOVE'].present?
    end

    def enable_google_tracking?
      ::Rails.env.production?
    end

    def email_notification_enabled?
      ENV['SKIP_EMAIL_NOTIFICATION'].blank? && !!WebConfig.for('notifications.email.enabled')
    end

    def localized?
      I18n.available_locales.size > 1
    end

    def detect_spam?
      Rails.env.production? && !ENV['SPAM_DETECTOR_DISABLED']
    end
  end
end
