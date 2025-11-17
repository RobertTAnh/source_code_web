module CategoryOps
  class GetCategories < BaseOperation
    include CommonOperation::Paginatable
    
    def initialize(context, slug)
      @context = context
      @slug = slug
    end

    def call
      {
        data: get_categories,
        paging: paging_summary
      }
    end

    private

    attr_reader :context, :slug

    def get_categories
      categories = []

      if slug
        category = Category.find_by slug: slug
        categories = category.posts.lastest
      end

      paginate(categories).to_a
    end
  end
end