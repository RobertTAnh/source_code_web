class ScssRenderer < BaseRenderer
  attr_accessor :template

  def initialize(template)
    @template = template
  end

  def render(context = nil, &block)
    # SassC::Engine.new(template).render

    environment = Sprockets::Railtie.build_environment(Rails.application)
    engine = SassC::Rails::SassTemplate.new
    engine.call(
      environment: environment,
      filename: '/',
      data: template.gsub("\n", ' '),
      metadata: {}
    )[:data]
  end
end
