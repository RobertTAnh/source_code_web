namespace :delayed_job do
  desc 'Check delayed jobs pending'
  task :check_pending_job => :environment do
    pending_job_count = Delayed::Job.where("created_at <= ?", Time.now - 30.minutes).count
    unless pending_job_count.zero?
      $slack_client.chat_postMessage(channel: ENV['SLACK_SYSOPS_CHANNEL'],
                               attachments: [{ color: 'danger', text: "⚠️ *#{ENV['WEB']} - Delayed Job Alert* ⚠️\n" +
                                               "The Delayed Job queue has *#{pending_job_count}* jobs pending and has not processed them within the last 30 minutes.\n"
                                            }])
    end
  end
end
