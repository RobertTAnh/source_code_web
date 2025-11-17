class HamlRenderer < BaseRenderer
  attr_accessor :template

  def initialize(template)
    @template = template
  end

  def render(context = nil, &block)
    if block_given?
     Haml::Engine.new(template).render(context) do
       yield
     end
    else
     Haml::Engine.new(template).render(context)
    end
  end
end
