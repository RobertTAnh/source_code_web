module OrderCmds
  class GetList
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
      @scope = Order.where.not(status: "draft").all
    end

    def filter_scope
      if params[:search].present?
        @scope = scope.where(["customer_name ilike :s OR customer_email ilike :s OR customer_phone ilike :s OR code ilike :s", s: "%#{params[:search].strip}%"])
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
