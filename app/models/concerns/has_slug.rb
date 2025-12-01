module HasSlug
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true

    before_validation :create_slug_from_name
  end

  def create_slug_from_name
    return if self.name.blank?
    return if self.slug == '/'

    if self.slug.present?
      slug = self.slug.split('/').map do |partial|
        Sluggable.new(partial).to_slug
      end.join('/')

      return errors.add(:slug, :invalid) if slug.blank?

      self.slug = slug

      return
    end

    self.slug = Sluggable.new(self.name).to_slug
  end
end
