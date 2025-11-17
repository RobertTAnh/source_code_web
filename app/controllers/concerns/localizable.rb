module Localizable
  extend ActiveSupport::Concern

  module OverrideMethods
    def default_url_options
      super.merge({
        locale: I18n.locale
      })
    end
  end

  included do
    prepend OverrideMethods
    around_action :switch_locale, unless: :devise_controller?
  end

  def switch_locale(&action)
    locale = detect_locale

    if params[:locale]&.to_sym != locale && I18n.default_locale != locale
      redirect_to url_for(locale: :en)
      return
    end

    I18n.with_locale(locale, &action)
  end

  def detect_locale
    locale = (params[:locale] || session[:locale] || detect_locale_from_request || I18n.default_locale).to_sym

    session[:locale] = locale unless session[:locale]&.to_sym == locale

    locale
  end

  def detect_locale_from_request
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/[a-z]{2}(?=;)/)&.find do |locale|
      I18n.available_locales.include?(locale.to_sym)
    end
  end
end
