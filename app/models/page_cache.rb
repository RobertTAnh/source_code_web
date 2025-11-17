class PageCache
 def self.remove_cached_pages
    return unless Settings.page_caching_enabled?

   if Settings.page_caching_scheduled_remove?
     set_page_cache_expired
   else
     remove_cache_directory
   end
 end

 def self.set_page_cache_expired
   WebConfig.current.add_string 'page_caching.expired_at_timestamp', Time.now.to_i
 end

 def self.scheduled_remove_cached_pages(listener = nil)
   listener ||= proc {}

   listener.call('check cache expired')

   unless Settings.page_caching_enabled?
     listener.call('page caching is not enabled')
     return
   end
   
   expired = WebConfig.for('page_caching.expired_at_timestamp')

   if expired.blank?
     listener.call('expiration not found')
     return
   end

   cache_dir = Settings.page_caching_directory

   oldest = Dir.glob(cache_dir.join('**/*')).map do |file|
     File.mtime(file)
   end.min

   if oldest.blank?
     listener.call('cached pages not found')
     return
   end


   if expired.to_i < oldest.to_i
     listener.call('cached pages are fresh')
     return
   end

   remove_cache_directory

   listener.call('cached pages are removed')

   true
 end

 def self.remove_cache_directory
    cache_dir = Settings.page_caching_directory

    return unless File.exists?(cache_dir)

    tmp = "#{cache_dir}-#{SecureRandom.hex}"

    system("mv #{cache_dir} #{tmp} && rm -rf #{tmp}")
 end
end
