module ProductOps
  class GetProducts < BaseOperation
    include CommonOperation::Paginatable
    include ::DefaultSort
    SUPPORTED_VALUE_SORTS = ["asc", "desc"]

    def call
      get_products

    end

    private

    def get_products
      web_config = WebConfig.for('products.properties')
      configs = web_config.present? && web_config["sections"].present? ? web_config["sections"].map{|data| data["configs"].map{|v| v.is_a?(Array) ? v.map{|i| i["key"]} : v["key"]}}.flatten : []

      products = []
      if context.params[:category_slug]
        category = Category.find_by slug: context.params[:category_slug]
        products = category.products

      else
        products = Product.lastest
      end

      if context.params["product_ids"].present?
        product_ids = context.params["product_ids"].split(',').map(&:to_i).compact.uniq
        products = products.where(id: product_ids)  
      end

      if context.params["sort"].present?
        context.params["sort"].each do |k, v|
          products = products.order(k => v) if Product::SUPPORTED_FIELD_SORTS.include?(k) && SUPPORTED_VALUE_SORTS.include?(v.downcase)
        end
      else
        products = apply_default_sort(products, 'products', Product::SUPPORTED_FIELD_SORTS).lastest
      end

      if context.params["price_range"].present?
        price_range = context.params["price_range"].split(',').map(&:to_i)
        products = products.where(price: price_range[0]..price_range[1])
      end

      configs.each do |data|
        if context.params[data].present?
          products = products.where("properties->'#{data}'->>'key' IN (?)", context.params[data].split("/")[0].split(","))
        end
      end

      products = paginate(products).to_a
    end
  end
end