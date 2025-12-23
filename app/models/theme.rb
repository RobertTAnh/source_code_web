class Theme < ApplicationRecord
  delegate :render_page, :render_view, to: :theme_renderer
  delegate :inline_javascript, :inline_stylesheet, to: :theme_renderer
  delegate :javascript_tag, :stylesheet_tag, to: :theme_renderer
  delegate :compile_javascript, :compile_stylesheet, to: :theme_renderer

  def theme_renderer
    @theme_renderer ||= ThemeRenderer.new(self)
  end

  def self.current
    @current ||= Theme.first
  rescue ActiveRecord::NoDatabaseError
    nil
  rescue ActiveRecord::ConnectionNotEstablished, PG::ConnectionBad
    nil
  rescue ActiveRecord::StatementInvalid => e
    if e.message.match(/relation "themes" does not exist/)
      nil
    else
      raise e
    end
  end

  def config
    @config ||= load_config
  end

  def local_path
    theme_location = ENV['THEME_LOCATION'] || 'app/views/themes'

    @local_path ||= Rails.root.join(theme_location, self.path)
  end

  # TODO: check if theme is local & let theme detect it's file
  def load_config
    config_file = local_path.join('theme.json')

    return {} unless config_file.exist?

    JSON.parse(File.read(config_file))
  end
end
