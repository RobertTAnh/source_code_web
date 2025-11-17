module CommonOperation
  module Paginatable
    FALLBACK_PAGE_SIZE = 12

    attr_reader :paging_scope

    def paginate(scope)
      @paging_scope = scope

      scope.offset(current_paging_offset).limit(page_size)
    end

    def current_paging_offset
      (current_page - 1) * page_size
    end

    def current_page
      [context.params[:page].to_i, 1].max
    end

    def page_size
      raise StandardError, 'Call paginate first' unless @paging_scope

      value = WebConfig.for("paging.#{@paging_scope.klass.name.downcase}.page_size")
      value = WebConfig.for('paging.page_size') if value.blank?
      value = FALLBACK_PAGE_SIZE if value.blank?
      value.to_i
    end

    def total_items
      raise StandardError, 'Call paginate first' unless @paging_scope

      @paging_scope.count
    end

    def total_pages
      (total_items / page_size.to_f).ceil
    end

    def paging_summary
      {
        page: current_page,
        page_size: page_size,
        total_items: total_items,
        total_pages: total_pages
      }
    end
  end
end
