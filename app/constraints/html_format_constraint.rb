class HtmlFormatConstraint < BaseConstraint
  def self.matches?(request)
    html_format?(request)
  end
end
