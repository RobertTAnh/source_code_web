class Resource < ApplicationRecord
  self.inheritance_column = :type

  LOGGABLE_RELATIONS = %w|view content tags categorizations extra_fields|

  include SoftDelete
  include HasContent
  include HasTag
  include HasProperties
  include Viewable
  include HasMedias
  include HasStatus
  include HasCategories
  include HasExtraFields
  include HasLocale if Settings.localized?
  include PgSearch

  has_one_attached :image

  validates :name, presence: true
  pg_search_scope :admin_search,
    against: [:name, :slug],
    associated_against: {
      global_slugs: :name }  

  def self.properties_config
    config = WebConfig.custom_resource_config.find{|res| res[:name] == self.name}

    config ? config[:attributes].as_json : {}
  end

  def self.extra_fields_by_config
    WebConfig.for("#{name.underscore.pluralize}.extra_fields")
  end
end
