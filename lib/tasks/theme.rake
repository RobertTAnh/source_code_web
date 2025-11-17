namespace :theme do
  desc 'Link theme assets'
  task :link_assets => :environment do
    next unless Theme.current

    logger.info 'Setup theme: linking assets...'

    target = Rails.public_path.join('tassets')

    if File.exists?(target)
      raise "Could not link theme assets, file or directory exists: #{target}" unless File.symlink?(target)
      system("unlink #{target}")
    end

    system("ln -s #{Theme.current.local_path.join('tassets')} #{Rails.public_path}")
  end

  desc 'Compile theme assets'
  task :compile do
    logger.info 'Compiling theme assets'

    if Theme.current
      Theme.current.compile_stylesheet
      Theme.current.compile_javascript
    else
      default_theme = Theme.new(path: ENV["WEB"],  name: "default", is_default: true, source: "local")

      default_theme.compile_stylesheet
      default_theme.compile_javascript
    end
  end

  def logger
    @logger ||= ActiveSupport::Logger.new(STDOUT)
  end
end

local_precompile = ENV['APP_ENV_LOCAL_PRECOMPILE']

if local_precompile == 'true'
  Rake::Task['assets:precompile'].enhance ['theme:compile']
else
  Rake::Task['assets:precompile'].enhance ['theme:compile', 'theme:link_assets']
end
