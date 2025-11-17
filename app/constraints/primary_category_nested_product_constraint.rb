class PrimaryCategoryNestedProductConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:product]

    return unless global_slug&.sluggable_type == 'Product'

    global_slug.sluggable.primary_category&.slug == request.params[:primary_category]
  end

  def self.build_route_params(product)
    primary_category = product.primary_category

    { product: product.slug, primary_category: primary_category&.slug || 'undefined' }
  end

  localized if Settings.localized?
end
