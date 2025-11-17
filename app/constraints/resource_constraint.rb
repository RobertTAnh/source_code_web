class ResourceConstraint < BaseConstraint
  def self.resource_type
    raise NotImplementedError
  end

  def self.matches?(request)
    return false unless html_format?(request)

    global_slug = detect_global_slug request.params[:slug]

    global_slug&.sluggable_type == resource_type
  end

  def self.[](type)
    Class.new(self) do
      eval "def self.resource_type; '#{type}' end"
    end
  end

  localized if Settings.localized?
end
