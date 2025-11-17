class PageContent < ApplicationRecord
  after_save :clear_cache

  def self.display_data_for(owner)
    fetch_cached_data(owner)
  end

  def self.for_owner(owner)
    fetch_cached_record(owner)
  end

  def self.update_for(owner, data)
    record = find_or_initialize_by(owner_type: owner.class.name, owner_id: owner.id)
    record.data = data
    record.save!
  end

  def self.fetch_cached_data(owner)
    Rails.cache.fetch("page_contents/data/#{owner.class.name}/#{owner.id}") do
      (for_owner(Theme.current)&.data || {}).merge(for_owner(owner)&.data || {})
    end
  end

  def self.fetch_cached_record(owner)
    Rails.cache.fetch("page_contents/record/#{owner.class.name}/#{owner.id}") do
      where(owner_type: owner.class.name, owner_id: owner.id).first
    end
  end

  def clear_cache
    if owner_type == 'Theme'
      Rails.cache.delete_matched("page_contents/*")
    else
      Rails.cache.delete("page_contents/record/#{owner_type}/#{owner_id}")
      Rails.cache.delete("page_contents/data/#{owner_type}/#{owner_id}")
    end
  end
end
