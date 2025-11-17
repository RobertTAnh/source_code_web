# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
require 'dotenv'
Dotenv.load('.env', ".env.#{@environment}")

if ENV['PAGE_CACHING_SCHEDULED_REMOVE']
  every 1.minute do
    rake 'cache:remove_cached_pages'
  end
end

every :day, at: "07:2#{Array(0..9).sample}am" do
  rake 'sitemap:refresh'
end

every :day, at: "07:0#{Array(0..9).sample}am" do
  rake 'posts:release_posts'
end

every Array(50..60).sample.minutes do
  rake 'delayed_job:check_pending_job'
end

every  (ENV["JOB_WORKOFF_DELAY"]&.to_i || Array(10..15).sample).minutes do
  rake 'jobs:workoff'
end
