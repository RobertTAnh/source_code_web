module RouteHelper
  # Use outside of view
  module Methods
    extend Rails.application.routes.url_helpers
    extend ::RouteHelper

    # TODO: Need to provide url options here
    def self.url_options
      {
        trailing_slash: true
      }
    end
  end

  if WebConfig.for_constant('routes.product.constraints')
    def product_path(product, params = {})
      super(WebConfig.for_constant('routes.product.constraints').build_route_params(product), **params)
    end
  else
    def product_path(product, params = {})
      super(product: product.try(:slug) || product, **params)
    end
  end

  if WebConfig.for_constant('routes.post.constraints')
    def post_path(post, params = {})
      super(WebConfig.for_constant('routes.post.constraints').build_route_params(post), **params)
    end
  else
    def post_path(post, params = {})
      super(post: post.try(:slug) || post, **params)
    end
  end


  def category_path(category, params = {})
    super(category: category.try(:slug) || category, **params)
  end

  def page_path(page, params = {})
    return root_path(params) if (page.try(:slug) || page) == '/'
    super(page: page.try(:slug) || page, **params)
  end

  WebConfig.custom_resource_config.each do |resource|
    # Example usage: policy_path
    define_method "#{resource[:name].underscore}_path" do |record|
      super(slug: record.try(:slug) || record)
    end
  end

  def resource_path(resource, resource_type = nil, params = {})
    # Fallback to legacy call: resource_path('Staff', staff)
    if resource.is_a?(String) && resource.classify == resource
      return send "#{resource.underscore}_path", resource_type.try(:slug) || resource_type, **params
    end

    send "#{(resource_type || resource.class.name).underscore}_path", resource.try(:slug) || resource, **params
  end

  def path_for record
    if record.is_a? Product
      product_path record
    elsif record.is_a? Category
      category_path record
    elsif record.is_a? Post
      post_path record
    elsif record.is_a? Page
      page_path record
    elsif record.is_a? Resource
      resource_path record
    else
      '/'
    end
  end

  def full_url_for_record(record)
    "#{request.base_url}#{path_for(record)}"
  end
end
