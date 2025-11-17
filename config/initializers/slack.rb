Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

$slack_client = Slack::Web::Client.new
