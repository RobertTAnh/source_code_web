module HasGlobalSlug
  extend ActiveSupport::Concern

  class SlugValidator < ActiveModel::Validator
    def validate(record)
      return unless record.slug_changed? && record.slug.present?
      return unless GlobalSlug.where.not(sluggable: record).where(name: record.slug, locale: record.locale).exists?

      record.errors.add :global_slugs, :taken
    end
  end

  included do
    has_many :global_slugs, class_name: 'GlobalSlug', as: :sluggable, dependent: :destroy

    validates_with SlugValidator

    after_save :create_global_slug
  end

  def create_global_slug
    return unless slug_previously_changed?

    if global_slug = GlobalSlug.find_by(sluggable: self, name: slug)
      global_slug.update!(primary: true)
    else
      global_slug = GlobalSlug.create!(sluggable: self, name: slug, locale: locale, primary: true)
    end

    GlobalSlug.where(sluggable: self, primary: true).where.not(id: global_slug.id).update_all(primary: false)
  end
end
