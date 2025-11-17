Rails.application.config.tap do |config|
  available_locales = ENV['LANGUAGES']&.split(',')&.map(&:to_sym).presence || [:vi]

  if available_locales.any?
    config.i18n.default_locale = available_locales.first
    config.i18n.available_locales = available_locales
    config.i18n.fallbacks = [:en]

    config.after_initialize do |app|
      next unless Theme.current
      I18n.load_path += Dir[Theme.current.local_path.join('locales', '*.{rb,yml}')]
    end
  end
end
