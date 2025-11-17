namespace :cache do
  desc 'Remove cached pages'
  task :remove_cached_pages => :environment do
    PageCache.scheduled_remove_cached_pages(-> (message) {
      logger.info "Rake[cache:remove_cached_pages]: #{message}"
    })
  end

  desc 'Clear cache'
  task :clear => :environment do
    logger.info "Clearing cache..."
    PageCache.remove_cached_pages
    ActionCache.remove_cached_actions
  end

  def logger
    @logger ||= ActiveSupport::Logger.new(STDOUT)
  end
end
