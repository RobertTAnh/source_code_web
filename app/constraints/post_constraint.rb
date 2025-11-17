class PostConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:post]

    global_slug&.sluggable_type == 'Post'
  end

  localized if Settings.localized?
end
