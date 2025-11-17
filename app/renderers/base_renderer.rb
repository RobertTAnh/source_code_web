class BaseRenderer
  def initialize(template)
    @template = template
  end

  def render(context = nil, &block)
    raise NotImplementedError
  end
end
