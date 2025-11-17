class CategoryConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:category]

    global_slug&.sluggable_type == 'Category'
  end

  localized if Settings.localized?
end
