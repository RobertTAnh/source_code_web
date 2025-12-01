class Product < ApplicationRecord
  LOGGABLE_RELATIONS = %w|variants content tags view categorizations extra_fields|
  SUPPORTED_FIELD_SORTS = ["created_at", "updated_at", "price", "display_order","view_count","discount_percentage", "published_at"]

  include SoftDelete
  include HasGlobalSlug
  include HasSlug
  include HasContent
  include HasExtraFields
  include Viewable
  include HasMedias
  include HasCategories
  include HasSku
  include HasStatus
  include HasProperties
  include HasTag
  include HasAlbum
  include HasVariants
  include HasComment
  include PgSearch
  include HasLocale if Settings.localized?
  include HasPublishedAt

  has_one_attached :image

  validates :name, presence: true

  # TODO: should remove these
  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  scope :default_sort, -> { order(display_order: :asc, created_at: :desc) }
  # Override published scope from enum to quickly apply default_sort to all displayed products
  # Should have a better way for this, eg: have different traits for web and admin
  scope :published, -> { default_sort.where(status: 'published') }
  scope :lastest, -> { published.order(created_at: :desc) }
  scope :tag, -> (name) { joins(:tags).where(tags: { name: name }) }

  pg_search_scope :general_search,
    against: [:name, :slug, :sku]
  pg_search_scope :admin_search,
    against: [:name, :slug, :sku],
    associated_against: {
      global_slugs: :name }  

  before_create :set_default_price
  before_save :set_discount

  def sold_out?
    false
  end

  def has_variant?
    false
  end

  def has_discount?
    discount_percentage && discount_percentage > 0
  end

  def calculate_discount_percentage
    if price.to_f > 0 && original_price.to_f > 0
      (((original_price - price).fdiv original_price) * 100).round(1)
    end
  end

  private

  def set_discount
    if price_changed? || original_price_changed?
      self.discount_percentage = calculate_discount_percentage
    end
  end

  def set_default_price
    self.price = 0
    self.original_price = 0
  end
end
