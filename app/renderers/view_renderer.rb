class ViewRenderer < BaseRenderer
  attr_accessor :template, :format

  def initialize(template:, format:)
    @template = template
    @format = format
  end

  def render(context, &block)
    formats = format.split('.')
    final_format = formats.shift

    result = formats.reverse.reduce(template) do |result, format|
      result = find_renderer(format).new(result).render(context) do
        yield if block_given?
      end
    end

    { standard_render_format(final_format).to_sym => result }
  end

  def standard_render_format(format)
    format = 'plain' if format == 'text'

    format
  end

  def find_renderer(format)
    "::#{format.titleize}Renderer".constantize
  end
end
