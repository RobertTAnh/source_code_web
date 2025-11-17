module PageOps
  class Category < BaseOperation
    include CommonOperation::Paginatable
    SUPPORTED_FIELD_SORTS = ["created_at", "updated_at", "price", "display_order","view_count","discount_percentage"]
    SUPPORTED_VALUE_SORTS = ["asc", "desc"]
    def call
      validate_params

      get_category

      load_data

      prepare_data

      render_view
    end

    private

    attr_reader :category, :products, :posts, :paging, :param_filters

    def validate_params
    end

    def get_category
      @category = ::Category.find_by slug: context.params[:category] 
    end

    def load_data
      additional_categories = WebConfig.additional_categories_for('products')
      data_key = additional_categories.present? ? additional_categories.map{|add_category| add_category["key"]} : []
      if category.product? || data_key.include?(category.kind)
        property_config = WebConfig.for('products.properties')
        configs = property_config&.dig('sections')&.map do |section|
          section['configs'] || []
        end&.flatten
        configs = configs ? configs.index_by{|config| config['key'] } : {}
        products = []
        @param_filters = []
        products = category.products

        if context.params["sort"].present?
          context.params["sort"].each do |k, v|
            products = products.order(k => v) if SUPPORTED_FIELD_SORTS.include?(k) && SUPPORTED_VALUE_SORTS.include?(v.downcase)
          end
        else
          products = products.lastest
        end

        if context.params["price_range"].present?
          price_range = context.params["price_range"].split(',').map(&:to_i)
          products = products.where(price: price_range[0]..price_range[1])
        end

        configs.each do |key, data|
          if context.params[key].present?
            @param_filters << context.params[key].split("/")[0]
            if data.present? && data["array"]
              data_options = context.params[key].split(",")
              options = data_options.map{|i| "%#{i}%"}
              query = data_options.map{|option| "properties->'#{key}'->>'key' LIKE ?"}.join(' or ')
              products = products.where(query, *options)
            else
              products = products.where("properties->'#{key}'->>'key' IN (?)", context.params[key].split("/")[0].split(","))
            end
          end
        end

        @products = paginate(products).to_a
      elsif category.post?
        @posts = paginate(category.posts.lastest).to_a
      end
    end

    def prepare_data
      context.instance_variable_set '@category', category
      context.instance_variable_set '@content', category.content
      context.instance_variable_set '@products', products
      context.instance_variable_set '@posts', posts
      context.instance_variable_set '@paging', paging_summary if paging_scope
      context.instance_variable_set '@param_filters', param_filters
    end

    def render_view
      context.render_for category
    end
  end
end
