class Page < ApplicationRecord
  LOGGABLE_RELATIONS = %w|content tags view extra_fields|

  include SoftDelete
  include HasGlobalSlug
  include HasSlug
  include HasContent
  include HasExtraFields
  include Viewable
  include HasSlug
  include HasMedias
  include HasStatus
  include HasTag
  include HasAlbum
  include HasLocale if Settings.localized?
  include PgSearch

  has_one_attached :image

  validates :name, presence: true
  pg_search_scope :admin_search,
  against: [:name, :slug],
  associated_against: {
    global_slugs: :name }  

  def self.home
    @home ||= find_by(slug: '/')
  end
end
