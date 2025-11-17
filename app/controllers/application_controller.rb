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
end
