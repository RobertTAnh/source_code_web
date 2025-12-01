module CommentCmds
  class List
    prepend BaseCmd

    def initialize(context:, params:)
      @context = context
      @params = params
    end

    def call
      step :base_scope
      step :filter_scope
      step :paginate_scope
      step :result
    end

    private

    attr_reader :context, :params, :scope

    def base_scope
      @scope = scoped(:read, :comment).where(is_admin: false, depth: 0)
    end

    def filter_scope
      if params[:status].present?
        @scope = @scope.where(status: params[:status])
      end

      if params[:owner_type].present?
        @scope = @scope.where(owner_type: params[:owner_type])
      end
    end

    def paginate_scope
      @scope = scope.page(current_page).per(page_size)
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
