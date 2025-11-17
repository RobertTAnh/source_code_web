module HasSlug
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true

    before_validation :create_slug_from_name
  end

  def create_slug_from_name
    return if self.name.blank?
    return if self.slug.present?

    self.slug = Sluggable.new(self.name).to_slug
  end
end
