module ActionCachable
  extend ActiveSupport::Concern

  included do
    if Settings.action_caching_enabled?
      before_action :action_cache_flush
      caches_action :home, :page, :category, :product, :post,
        expires_in: (ENV['ACTIONCACHE_EXPIRED_TIME'] || 24).to_i.hours,
        cache_path: :action_cache_path
    end
  end

  def action_cache_path(path = nil)
    [Settings.action_caching_key, ActiveStorage::Filename.new(CGI.escape(path || request.fullpath)).sanitized, params[:no_cache] ? Time.now.to_i : ''].join
  end

  def action_cache_flush
    if params[:flush_cache].in? ['all/', 'all']
      Rails.cache.clear
    elsif params[:flush_cache]
      expire_fragment %r{#{action_cache_path(request.fullpath)}*}
    end
  end
end
