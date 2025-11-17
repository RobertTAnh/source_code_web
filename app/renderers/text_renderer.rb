class TextRenderer < BaseRenderer
  attr_accessor :template

  def initialize(template)
    @template = template
  end

  def render(context = nil)
    template
  end
end
