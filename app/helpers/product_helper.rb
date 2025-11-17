module ProductHelper
  def featured_products
    @featured_products ||= ProductOps::GetFeaturedProducts.new(context: self).call
  end
end
