module HasLocale
  extend ActiveSupport::Concern

  included do
    before_create :set_locale
    before_validation :set_universal_slug, if: :new_record?

    default_scope -> { where(locale: I18n.locale) }

    validates :universal_slug, uniqueness: { scope: :locale }
  end

  def clone_to_locale locale
    I18n.with_locale locale.to_sym do
      self.dup.tap do |record|
        record.locale = locale
        record.view_id = nil
        record.content = content.dup if record.respond_to?(:content)
        record.view = view.dup if record.respond_to?(:view)
        record.depth = 1 if record.is_a? Category
        record.parent_id = nil if record.is_a? Category
        record.save!
      end
    end
  end

  def available_locales
    @available_locales ||= self.class.unscope(where: :locale).where(universal_slug: self.universal_slug).pluck(:locale)
  end

  private

  def set_locale
    self.locale = I18n.locale
  end

  def set_universal_slug
    self.universal_slug = self.slug unless self.universal_slug
  end
end
