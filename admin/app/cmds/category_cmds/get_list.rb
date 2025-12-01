module CategoryCmds
  class GetList
    prepend BaseCmd
    include ::DefaultSort

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
      @scope = scoped(:read, :category).where(depth: 1)
    end

    def filter_scope
      if params[:search].present?
        @scope = Category.admin_search(params[:search].strip)
      elsif params[:kind].present?
        @scope = scope.where(kind: params[:kind])
      end
    end

    def paginate_scope
      @scope = scope.page(current_page).per(page_size)
    end

    def sort_scope
      @scope = apply_default_sort(@scope, 'categories', Category::SUPPORTED_FIELD_SORTS) do
        @scope.order(created_at: :desc)
      end
    end

    def result
      scope
    end

    def current_page
      [params[:page].to_i, 1].max
    end

    # TODO: use default global page size
    def page_size
      params[:page_size] ? params[:page_size].to_i : 25
    end
  end
end
