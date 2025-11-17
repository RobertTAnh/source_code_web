class PageConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:page]

    global_slug&.sluggable_type == 'Page'
  end

  localized if Settings.localized?
end
