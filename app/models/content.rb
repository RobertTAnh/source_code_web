class Content < ApplicationRecord
  belongs_to :owner, polymorphic: true, touch: true
  # validates_length_of :meta_title, maximum: 60, allow_blank: true
  # validates_length_of :meta_description, maximum: 160, allow_blank: true
  include HasTableOfContent

  validates_each :seo_schema, :seo_schema_breadcumb do |record, attr, value|
    begin
      JSON.parse value if value.present? && value.is_a?(String)
    rescue JSON::ParserError
      record.errors.add(attr, 'Invalid json format')
    end
  end

  has_one_attached :meta_image
  before_save :parse_seo_schema_json,
    if: Proc.new {|content| content.seo_schema_breadcumb_changed? || content.seo_schema_changed?}

  private

  def parse_seo_schema_json
    if seo_schema.present? && seo_schema.is_a?(String)
      self.seo_schema = JSON.parse seo_schema
    end

    if seo_schema_breadcumb.present? && seo_schema_breadcumb.is_a?(String)
      self.seo_schema_breadcumb = JSON.parse seo_schema_breadcumb
    end

    self.seo_schema = nil if self.seo_schema.blank?
    self.seo_schema_breadcumb = nil if self.seo_schema_breadcumb.blank?
  end
end
