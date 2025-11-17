module RenderingHelper
  def render_html(content)
    content&.html_safe
  end
end
