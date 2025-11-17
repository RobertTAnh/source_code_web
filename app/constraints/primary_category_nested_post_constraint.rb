class PrimaryCategoryNestedPostConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:post]

    return unless global_slug&.sluggable_type == 'Post'

    global_slug.sluggable.primary_category&.slug == request.params[:primary_category]
  end

  def self.build_route_params(post)
    primary_category = post.primary_category

    { post: post.slug, primary_category: primary_category&.slug || 'undefined' }
  end

  localized if Settings.localized?
end
