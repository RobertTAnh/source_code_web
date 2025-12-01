class Category < ApplicationRecord
  LOGGABLE_RELATIONS = %w|content tags extra_fields|
  SUPPORTED_FIELD_SORTS = ["created_at", "updated_at", "price", "display_order", "view_count", "published_at"]

  include SoftDelete
  include HasGlobalSlug
  include HasSlug
  include HasContent
  include HasExtraFields
  include Viewable
  include HasStatus
  include HasMedias
  include HasTag
  include HasAlbum
  include HasComment
  include HasLocale if Settings.localized?
  include PgSearch
  include HasPublishedAt

  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: :parent_id, dependent: :destroy

  has_many :categorizations

  has_many :products, through: :categorizations, source_type: 'Product', source: :categorizable
  has_many :posts, through: :categorizations, source_type: 'Post', source: :categorizable

  WebConfig.custom_resource_config.select { |resource| resource[:has_category] }.each do |resource|
    has_many resource[:name].underscore.pluralize.to_sym, through: :categorizations, source_type: resource[:name], source: :categorizable
  end

  enum kind: { product: 'product',
               post: 'post',
               service: 'service'
             }.merge(
               WebConfig.custom_resource_config.select { |resource| resource[:has_category] }
                .map { |resource| resource[:name].underscore }
                .map { |item|  [item, item] }
                .to_h
             ).merge(
               WebConfig.additional_categories_for('all')
                 .map{ |add_category| [add_category['key'], add_category['key']]}
                 .to_h
             )

  has_one_attached :image

  scope :default_sort, -> { order(display_order: :asc, created_at: :desc) }
  scope :published, -> { default_sort.where(status: 'published') }
  scope :by_kind, -> (kind) { where(kind: kind) }
  scope :root, -> { where(parent_id: nil) }

  pg_search_scope :admin_search,
    against: [:name, :slug],
    associated_against: {
      global_slugs: :name }  

  # TODO: move to command
  def self.all_product_categories
    Category.product.published.where(parent_id: nil).includes(children: [{ children: [{children: :children}] }]).to_a
  end

  def self.all_post_categories
    Category.post.published.where(parent_id: nil).includes(children: [{ children: [{children: :children}] }]).to_a
  end

  def self.all_service_categories
    Category.service.published.where(parent_id: nil).includes(children: [{ children: [{children: :children}] }]).to_a
  end

  def self.all_tag_names(kind)
    Category.joins(:tags).where(kind: kind).pluck("tags.name").uniq
  end

  # TODO: move to somewhere
  def featured_30_products
    @featured_products ||= products.published.lastest.limit(30).to_a
  end

  def featured_10_products
    @featured_products ||= products.published.lastest.limit(10).to_a
  end

  def featured_products
    @featured_products ||= products.published.lastest.limit(8).to_a
  end

  def featured_4_products
    @featured_4_products ||= products.published.lastest.limit(4).to_a
  end

  def best_sales_products
    @best_sales_products ||= products.published.limit(3).to_a
  end

  def featured_10_posts
    @featured_10_products ||= posts.published.limit(10).to_a
  end
  
  def featured_3_posts
    @featured_3_products ||= posts.published.limit(3).to_a
  end

  def featured_4_posts
    @featured_4_products ||= posts.published.limit(4).to_a
  end

  def featured_post
    @featured_post ||= posts.published.order('categorizations.primary' => :desc).first
  end

  def products_filter_options_for(category, key)
    Rails.cache.fetch("on_product/products_filter_options_for_#{category}_#{key}", expires_in: 1.hours) do
      products.published.pluck(:properties).map{|a| a&.dig(key) if a&.dig(key, 'data').present?}.uniq.compact
    end
  end

  def root?
    !self.parent_id
  end
end
