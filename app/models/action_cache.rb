class ActionCache
  def self.remove_cached_actions
    return unless Settings.action_caching_enabled?

    if Settings.action_caching_scheduled_remove?
      raise NotImplementedError
    else
      clear_cache
    end
  end

  def self.clear_cache
    Rails.cache.delete_matched("#{Settings.action_caching_key}*")
  end
end
