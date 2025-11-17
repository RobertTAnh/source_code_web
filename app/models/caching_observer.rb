class CachingObserver < ActiveRecord::Observer
  observe :product, :page, :post, :category, :web_config, :resource, :page_content

  def after_save(record)
    clear_cached_pages
    clear_cached_segments record
  end

  def after_create(record)
    clear_cached_pages
    clear_cached_segments record
  end

  def after_destroy(record)
    clear_cached_pages
    clear_cached_segments record
  end

  private

  def clear_cached_pages
    PageCache.remove_cached_pages
    ActionCache.remove_cached_actions
  end

  def clear_cached_segments(record)
    Rails.cache.delete_matched("on_#{record.class.name.downcase}/*")
    Rails.cache.delete_matched("on_all/*")
  end
end
