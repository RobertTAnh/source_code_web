namespace :posts do
  desc 'Release posts'
  task :release_posts => :environment do
    logger.info "Release posts in #{ Time.zone.now.strftime('%d-%m-%Y') }"
    PostCmds::ScheduleRelease.call
  end

  def logger
    @logger ||= ActiveSupport::Logger.new(STDOUT)
  end
end
