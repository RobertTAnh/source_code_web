module Admin
  module WebRouteHelper
    extend ActiveSupport::Concern

    def web_path_for(record, params={})
      if record.is_a? Product
        RouteHelper::Methods.product_path(record, params)
      elsif record.is_a? Category
        RouteHelper::Methods.category_path(record, params)
      elsif record.is_a? Post
        RouteHelper::Methods.post_path(record, params)
      elsif record.is_a? Page
        RouteHelper::Methods.page_path(record, params)
      elsif record.is_a? Resource
        RouteHelper::Methods.resource_path(record, nil, params)
      else
        '/'
      end
    end
  end
end
