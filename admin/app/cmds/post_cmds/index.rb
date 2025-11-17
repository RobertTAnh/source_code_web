module PostCmds
  class Index
    prepend BaseCmd

    def initialize(context:, params:)
      @context = context
      @params = params
    end

    def call
      step :base_scope
      step :filter_scope
      step :paginate_scope
      step :sort_scope
      step :result
    end

    private

    attr_reader :context, :params, :scope

    def base_scope
      @scope = Post.all
    end

    def filter_scope
      if params[:search].present?
        @scope = scope.admin_search(params[:search].strip)
      end
      if params[:filter_category] && params[:filter_category] != "All"
        category = Category.find(params[:filter_category])
        @scope = @scope.merge(category.posts) if category
      end
    end  

    def paginate_scope
      @scope = scope.page(current_page).per(page_size)
    end

    def sort_scope
      @scope = @scope.order(created_at: :desc)
    end

    def result
      scope
    end

    def current_page
      [params[:page].to_i, 1].max
    end

    # TODO: use default global page size
    def page_size
      params[:page_size] ? params[:page_size].to_i : 20
    end
  end
end
