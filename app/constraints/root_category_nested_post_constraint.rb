class RootCategoryNestedPostConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:post]

    return unless global_slug&.sluggable_type == 'Post'

    global_slug.sluggable.primary_root_category&.slug == request.params[:root_category]
  end

  def self.build_route_params(post)
    root_category = post.primary_root_category

    { post: post.slug, root_category: root_category&.slug || 'undefined' }
  end

  localized if Settings.localized?
end
