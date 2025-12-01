class ApplicationController < ActionController::Base
  include RouteHelper
  include Localizable if Settings.localized?

  before_action :load_theme

  attr_reader :theme

  def load_theme
    @theme = Theme.current
  end

  class ViewNotFoundError < StandardError; end

  helper_method :render_view

  def render_view(identity, **args)
    theme.render_view identity, view_context, **args
  end

  def render_for(viewable, **args)
    target = if args&.delete(:cache)
      Rails.cache.fetch("#{Settings.action_caching_key}/_404") do
        theme.render_page(viewable, view_context)
      end
    else
      theme.render_page(viewable, view_context)
    end

    options = { layout: false }.merge(args)

    if target.is_a?(Hash)
      render target.merge!(options)
    else
      render target, **options
    end
  end

  helper_method :customer_uuid

  def customer_uuid
    session[:customer_uuid] = CustomerUuid.new unless session[:customer_uuid]
    session[:customer_uuid]
  end

  helper_method :draft_order

  def draft_order
    @draft_order ||= Order.draft.where(customer_uuid: customer_uuid).first
  end

  def render_not_found
    @theme_option_seo_noindex = true

    render_for '404', status: :not_found, cache: true
  end

  def default_url_options
    {
      trailing_slash: true
    }
  end

  def detect_spam
    # if params['email']&.match(ENV['SPAM_EMAIL_MATCH'] || /test/)
    #   return render json: { result: 'success' }, status: :created
    # end

    ip = request.remote_ip
    is_blocked = IpLog.where(ip: ip, spam: true).where('created_at >= ?', Time.now - (ENV['SPAM_BLOCK_HOURS']&.to_f || 1).hours).exists?
    if is_blocked
      logger.info "Spam detected from #{ip}: #{params.to_s}"
      return render json: { result: 'success' }, status: :created
    else
      log = IpLog.create ip: ip, action: "#{controller_name}:#{action_name}"
      total_in_time = IpLog.where(ip: ip).where('created_at >= ?', Time.now - (ENV['SPAM_DETECT_MINUTES']&.to_f || 2).minutes).to_a

      if total_in_time.size > (ENV['SPAM_DETECT_COUNT']&.to_i || 5)
        total = IpLog.where(ip: ip).to_a
        total_group_by_actions = total.group_by(&:action)
        group_by_actions_in_time = total_in_time.group_by(&:action)
        log.update spam: true
        $slack_client.chat_postMessage(
          channel: ENV['SLACK_SYSOPS_CHANNEL'],
          attachments: [{ color: '#FFFF00', text: "⚠️ *#{ENV['WEB']} - Spam Detected Alert* ⚠️\n" +
                          "IP address #{ip} has been flagged for potential spam activity.\n" +
                          "#{[group_by_actions_in_time["contacts:create"].present? ? "#{group_by_actions_in_time['contacts:create'].size} contacts" : nil,
                              group_by_actions_in_time["orders:create"].present? ? "#{group_by_actions_in_time['orders:create'].size} orders" : nil].compact.join(', ')}" +
                          " have been registered in the last #{ENV['SPAM_DETECT_MINUTES']&.to_f || 2} minutes.\n" +
                          "A total of " +
                          "#{[total_group_by_actions["contacts:create"].present? ? "#{total_group_by_actions['contacts:create'].size} contacts" : nil,
                              total_group_by_actions["orders:create"].present? ? "#{total_group_by_actions['orders:create'].size} orders" : nil].compact.join(', ')}" +
                          " have been registered.\n" +
                          "Last request:\n" +
                          "```#{params.to_s}```"
          }])

        logger.info "Spam detected from #{ip}: #{params.to_s}"

        return render json: { result: 'success' }, status: :created
      end
    end
  end
end
