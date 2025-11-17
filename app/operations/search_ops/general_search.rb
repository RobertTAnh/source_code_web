module SearchOps
  class GeneralSearch < BaseOperation
    include CommonOperation::Paginatable

    def initialize(context, should_render: true)
      @context = context
      @should_render = should_render
    end

    def call
      validate_params

      search_products if !context.params[:search_form] || context.params[:search_form] == 'product'

      search_posts if !context.params[:search_form] || context.params[:search_form] == 'post'

      prepare_data

      render_view if should_render

      return_data
    end

    private

    attr_reader :context, :should_render, :products, :posts

    def validate_params
    end

    def search_posts
      key = context.params[:key]
      page = context.params[:page]

      if key.blank?
        @posts = []
      else
        @posts = ::Post.general_search(key)
        if page.present?
          @posts = paginate(@posts).to_a
        else
          @posts = @posts.limit(52).to_a
        end
      end
    end

    def search_products
      key = context.params[:key]
      page = context.params[:page]

      if key.blank?
        @products = []
      else
        @products = ::Product.general_search(key)
        if page.present?
          @products = paginate(@products).to_a
        else
          @products = @products.limit(52).to_a
        end
      end
    end

    def prepare_data
      context.instance_variable_set '@products', products
      context.instance_variable_set '@posts', posts
      context.instance_variable_set '@paging', paging_summary if paging_scope
    end

    def render_view
      context.render_for 'search'
    end

    def return_data
      if context.params[:search_form] == 'product'
        products
      elsif context.params[:search_form] == 'post'
        posts
      end
    end
  end
end

