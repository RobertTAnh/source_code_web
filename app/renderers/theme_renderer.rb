class ThemeRenderer
  attr_reader :theme

  def initialize(theme)
    @theme = theme
  end

  # Render a page
  def render_page(viewable, context)
    view = view_for viewable
    layout = layout_for viewable

    rendered_view = view.rendered(context).values.last

    if layout
      layout.rendered(context) do
        rendered_view
      end
    else
      rendered_view
    end
  end

  # TODO: DEPRECATED
  def stylesheet_tag(context)
    compile_stylesheet context

    %Q(<link rel="stylesheet" href="/assets/theme.#{theme.updated_at.to_i}.css" />)
  end

  # TODO: DEPRECATED
  def javascript_tag(context)
    compile_javascript context

    %Q(<script src="/assets/theme.#{theme.updated_at.to_i}.js" defer="defer"></script>)
  end

  def compile_stylesheet(context = {})
    content = view_loader.all_stylesheet_views.map do |view|
      view.rendered(context).values.last
    end.join("\n")

    File.open(Rails.root.join('app', 'assets', 'builds', "theme.#{theme.name}.css"), 'wb') do |f|
      f << content
    end
  end

  def compile_javascript(context = {})
    content = view_loader.all_javascript_views.map do |view|
      view.rendered(context).values.last
    end.join("\n")

    File.open(Rails.root.join('app', 'assets', 'builds', "theme.#{theme.name}.js"), 'wb') do |f|
      f << content
    end
  end

  def inline_stylesheet(context)
    view_loader.all_stylesheet_views.map do |view|
      content = view.rendered(context).values.last

      %Q(<style type="text/css">\n#{content}\n</style>)
    end.join("\n")
  end

  def inline_javascript(context)
    view_loader.all_javascript_views.map do |view|
      content = view.rendered(context).values.last

      %Q(<script defer="defer">\n#{content}\n</script>)
    end.join("\n")
  end

  # Render a partial
  def render_view(identity, context, **args)
    Rails.logger.debug "ThemeRenderer: render view #{identity}"

    args ||= {}

    view = view_loader.view_by_identity identity

    assign_locals(context, args[:locals])

    begin
      view.rendered(context).values.last
    rescue StandardError => e
      Rails.logger.error "Error render view: #{view.inspect}"

      raise e
    end
  end

  def assign_locals(context, locals)
    if locals.present?
      locals.each do |key, value|
        context.instance_variable_set "@#{key}", value
        context.define_singleton_method(key.to_sym) { value }
      end
    end
  end

  # Detect default view for an viewable object
  #
  def view_for(viewable)
    view_loader.view_for viewable
  end

  def layout_for(viewable)
    view_loader.layout_for viewable
  end

  def local_theme_path
    theme.local_path
  end

  def local_theme_path_for(target)
    local_theme_path.join(target)
  end

  def local_theme_pages_path
    local_theme_path.join('pages/')
  end

  def local_theme_layouts_path
    local_theme_path.join('pages/')
  end

  def default_layout
    ''
  end

  def view_loader
    @view_loader ||= case theme.source
                     when 'database'
                       DatabaseViewLoader.new(self)
                     when 'local'
                       LocalViewLoader.new(self)
                     else
                       raise "Could not handle for theme source '#{source}'"
                     end
  end

  class BaseViewLoader
    attr_reader :theme

    def initialize(theme)
      @theme = theme
    end

    def view_for
      raise NotImplementedError
    end

    def layout_for(viewable)
    end

    def default_layout
    end
  end

  class DatabaseViewLoader < BaseViewLoader
    def view_for(viewable)
      return viewable.view if viewable.view

      View.find_by(view_type: 'page', viewable_type: viewable.class.name.downcase)
    end

    def layout_for(viewable)
      viewable.layout
    end
  end

  class LocalViewLoader < BaseViewLoader
    def view_for(viewable)
      if viewable.respond_to?("view") && viewable.view
        view = viewable.view
      else
        pattern = case viewable
                  when Page
                    if viewable.slug == '/'
                      /^home/
                    else
                      /^static\/#{viewable.slug}/
                    end
                  when Category
                    /^category/
                  when Product
                    /^product/
                  when Post
                    /^post/
                  when Cart
                    /^cart/
                  when Resource
                    /^#{viewable.class.name.underscore}/
                  when String
                    /^#{viewable}/
                  else
                    raise "Could not handle view for #{viewable.class}"
                  end

        # TODO: to use method detect_file instead
        file = Dir.glob(theme.local_theme_pages_path.join('**/*')).detect do |file|
          File.file?(file) && file.split(theme.local_theme_pages_path.to_s).last.match(pattern)
        end

        unless file
          file = Dir.glob(Rails.root.join('app/views/shared').join('**/*')).detect do |file|
            File.file?(file) && file.split(Rails.root.join('app/views/shared').to_s).last.match(pattern)
          end
        end

        unless file
          raise "Could not find view for #{viewable.inspect}"
        end

        view = View.new code: 'loaded', name: 'Loaded', template: File.read(file), template_format: detect_view_format(file), path: Pathname.new(file).relative_path_from(Rails.root)
      end

      view
    end

    def view_by_identity(identity)
      file = detect_file(
        theme.local_theme_path,
        /#{identity}\./
      )

      file ||= detect_file(
        Rails.root.join('app/views/shared'),
        /#{identity}\./
      )

      raise StandardError.new("View not found for: #{identity}") unless file

      View.new template: File.read(file), template_format: detect_view_format(file)
    end

    def layout_for(viewable)
      default_layout
    end

    def all_stylesheet_views
      detect_files(
        theme.local_theme_path_for('styles'),
        /(?:\.css|\.scss)/
      ).map do |file|
        view_from_file file
      end
    end

    def all_javascript_views
      detect_files(
        theme.local_theme_path_for('javascripts'),
        /(?:\.js)/
      ).map do |file|
        view_from_file file
      end
    end

    def view_from_file(file)
      View.new template: File.read(file), template_format: detect_view_format(file)
    end

    def default_layout
      return @default_layout if @default_layout

      file = detect_file(
        theme.local_theme_path_for('layouts'),
        /\/?default/
      )

      @default_layout = View.new template: File.read(file), template_format: detect_view_format(file)
    end

    def detect_file(dir, pattern)
      file = Dir.glob(dir.join('**/*')).detect do |file|
        File.file?(file) && file.split(dir.to_s).last.match(pattern)
      end
    end

    def detect_files(dir, pattern)
      file = Dir.glob(dir.join('**/*')).select do |file|
        File.file?(file) && file.split(dir.to_s).last.match(pattern)
      end
    end

    def detect_view_format(path)
      if matches = path.match(/(\.\w{1,4})*$/)
        matches[0][1..]
      else
        raise "Could not detect view format for #{path}"
      end
    end
  end
end
