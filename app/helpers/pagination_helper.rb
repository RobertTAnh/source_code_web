module PaginationHelper
  def paging
    @paging
  end

  def pagination_path(page)
    path = request.original_fullpath.split('?', 2).first
    query = request.query_parameters
    query['page'] = page.to_s

    path + '?' + query.to_query
  end
end
