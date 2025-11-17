module ProductOps
  class GetProduct
    def initialize(context:, id: nil, slug: nil)
      @context = context
      @id = id
      @slug = slug
    end

    def call
      get_product
    end

    private

    attr_reader :context, :id, :slug

    def get_product
      if id.present?
        Product.find_by id: id
      else
        Product.find_by slug: slug
      end
    end
  end
end
