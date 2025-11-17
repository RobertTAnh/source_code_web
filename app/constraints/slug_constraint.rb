class SlugConstraint < BaseConstraint
  def self.matches?(request)
    return false unless html_format?(request)

    fullpath = request.original_fullpath

    global_slug = detect_global_slug(fullpath) || detect_global_slug(fullpath.delete_prefix('/'))

    !!global_slug
  end

  localized if Settings.localized?
end
