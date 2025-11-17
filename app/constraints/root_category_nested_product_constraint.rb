class RootCategoryNestedProductConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:product]

    return unless global_slug&.sluggable_type == 'Product'

    global_slug.sluggable.primary_root_category&.slug == request.params[:root_category]
  end

  def self.build_route_params(product)
    root_category = product.primary_root_category

    { product: product.slug, root_category: root_category&.slug || 'undefined' }
  end

  localized if Settings.localized?
end
