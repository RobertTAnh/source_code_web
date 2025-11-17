class GlobalSlug < ApplicationRecord
  include SoftDelete

  belongs_to :sluggable, polymorphic: true

  scope :primary, -> { where(primary: true) }

  default_scope -> { where(locale: I18n.locale) }

  def get_primary
    return self if self.primary?

    GlobalSlug.where(sluggable_type: self.sluggable_type, sluggable_id: self.sluggable_id, primary: true).first
  end
end
