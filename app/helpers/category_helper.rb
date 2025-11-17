module CategoryHelper
  def product_categories
    @product_categories ||= Category.all_product_categories
  end

  def post_categories
    @post_categories ||= Category.all_post_categories
  end

  def service_categories
    @service_categories ||= Category.all_service_categories
  end

  def param_filters
    @param_filters
  end
end
