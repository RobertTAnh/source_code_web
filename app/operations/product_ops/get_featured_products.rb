module ProductOps
  class GetFeaturedProducts
    def initialize(context:)
      @context = context
    end

    def call
      get_featured_products
    end

    private

    attr_reader :context

    def get_featured_products
      Product.published.order(created_at: :desc).limit(4).to_a
    end
  end
end
