module Admin
  module Localizable
    extend ActiveSupport::Concern
    
    included do
      around_action :switch_locale
    end
    
    def switch_locale(&action)
      save_locale
      locale = session[:admin_locale] || I18n.default_locale
      I18n.with_locale(locale.to_sym, &action)
    end

    def save_locale
      set_admin_locale params[:locale] if params[:locale].present?
    end

    def redirect_to_locale_record
      locale_redirect = params[:locale_redirect]
      return if locale_redirect.blank?

      locale_record = I18n.with_locale locale_redirect do
        if locale_slug = params[:locale_slug].presence&.strip
          locale_record = @record.class.find_by_slug(locale_slug)
          if locale_record
            locale_record.universal_slug = @record.universal_slug
            locale_record.save!
          end
        else
          locale_record = @record.class.find_by_universal_slug @record.universal_slug
          unless locale_record
            locale_record = @record.clone_to_locale I18n.locale
          end
        end

        locale_record
      end

      return unless locale_record

      set_admin_locale locale_redirect

      redirect_to send("edit_#{@record.class.name.underscore}_path", locale_record)
    end

    def set_admin_locale locale
      session[:admin_locale] = locale
    end
  end
end
