class ProductConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:product]

    global_slug&.sluggable_type == 'Product'
  end

  localized if Settings.localized?
end
