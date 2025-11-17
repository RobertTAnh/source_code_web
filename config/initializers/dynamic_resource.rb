if Rails.env.development?
  Rails.autoloaders.main.on_setup_callbacks << Proc.new do
    if Rails.application.initialized?
      load Rails.root.join('lib/loaders/dynamic_resource.rb')
    end
  end
end

Rails.application.config.after_initialize do
  load Rails.root.join('lib/loaders/dynamic_resource.rb')
end
