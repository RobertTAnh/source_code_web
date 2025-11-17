module PageOps
  class Product < BaseOperation
    def call
      validate_params

      get_product

      prepare_data

      increment_view_count

      render_view
    end

    private

    attr_reader :product

    def validate_params
    end

    def get_product
      @product = ProductOps::GetProduct.new(context: context, slug: context.params[:product]).call
    end

    def prepare_data
      context.instance_variable_set '@product', product
      context.instance_variable_set '@content', product.content
    end

    def increment_view_count
      product.increment!(:view_count) if product
    end

    def render_view
      context.render_for product
    end
  end
end
