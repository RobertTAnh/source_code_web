module AlbumCmds
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
      @scope = Album.where(owner: nil).all
    end

    def filter_scope
      if params[:search].present?
        @scope = scope.where(["name ilike :s OR slug ilike :s", s: "%#{params[:search].strip}%"])
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
