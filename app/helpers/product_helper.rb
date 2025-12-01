module ProductHelper
  def featured_products
    @featured_products ||= ProductOps::GetFeaturedProducts.new(context: self).call
  end

  def get_viewed_products
    return [] unless cookies[:viewed_products].present?

    viewed_products ||= Product.where(id: JSON.parse(cookies[:viewed_products])).published.limit(10).to_a
  end
end
