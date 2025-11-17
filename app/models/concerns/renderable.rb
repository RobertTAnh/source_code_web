module Renderable
  extend ActiveSupport::Concern

  def rendered(context = nil, &block)
    return @rendered if @rendered

    view = ViewRenderer.new(template: template, format: template_format)

    if block_given?
      view.render(context) do
        yield
      end
    else
      view.render(context)
    end
  end
end
