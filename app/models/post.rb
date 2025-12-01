class Post < ApplicationRecord
  LOGGABLE_RELATIONS = %w|content tags view categorizations extra_fields|
  SUPPORTED_FIELD_SORTS = ["created_at", "updated_at", "price", "display_order", "view_count", "published_at"]

  include SoftDelete
  include HasGlobalSlug
  include HasSlug
  include HasContent
  include HasExtraFields
  include Viewable
  include HasSlug
  include HasMedias
  include HasCategories
  include HasStatus
  include HasTag
  include HasAlbum
  include PgSearch
  include HasComment
  include HasLocale if Settings.localized?
  include HasPublishedAt

  has_one_attached :image

  validates :name, presence: true

  # TODO: how to build scope
  scope :default_sort, -> { order(display_order: :asc, created_at: :desc) }
  scope :published, -> { default_sort.where(status: 'published') }
  scope :unpublished, -> { default_sort.where(status: 'unpublished') }
  scope :lastest, -> { published.order(created_at: :desc) }
  scope :favorite, -> { published.order(created_at: :desc).offset(3).limit(3) }
  scope :popular, -> { published.unscope(:order).order(view_count: :desc).limit(5) }

  pg_search_scope :general_search,
    against: [:name, :slug, :description],
    associated_against: {
      content: :body }  
  pg_search_scope :admin_search,
    against: [:name, :slug],
    associated_against: {
      global_slugs: :name }  

  # TODO: related_products
  def related_products
    return []

    @related_products ||= Product.published.limit(3).to_a
  end

  def related_posts
    @related_posts ||= Post.published.order(created_at: :desc).limit(3)
  end

  def author
  end

  def published?
    status == 'published'
  end
end
