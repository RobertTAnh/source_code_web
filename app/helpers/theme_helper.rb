module ThemeHelper
  def theme_inline_stylesheet
    theme.inline_stylesheet(self)
  end

  def theme_inline_javascript
    theme.inline_javascript(self)
  end

  def theme_stylesheet_tag
    theme.stylesheet_tag(self)
  end

  def theme_javascript_tag
    theme.javascript_tag(self)
  end
end
