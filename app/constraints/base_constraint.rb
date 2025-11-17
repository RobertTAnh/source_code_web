class BaseConstraint
  def self.html_format?(request)
    request.format.html? || request.format == "*/*"
  end

  def self.detect_global_slug(slug)
    cached_slugs = RequestStore.store[:global_slugs] || {}

    unless global_slug = cached_slugs[slug]
      global_slug = GlobalSlug.find_by(name: slug)
      cached_slugs[slug] = global_slug || 'not_found'
      RequestStore.store[:global_slugs] = cached_slugs
    end

    RequestStore.store[:current_global_slug] = global_slug

    return if global_slug == 'not_found'

    global_slug
  end

  def self.localized
    class << self
      alias_method :original_matches?, :matches?

      def matches?(request)
        I18n.with_locale(request.params[:locale]) do
          original_matches?(request)
        end
      end
    end
  end
end
