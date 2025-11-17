class Variant < ApplicationRecord
  include HasProperties

  belongs_to :owner, polymorphic: true
  has_one_attached :image

  before_validation :generate_sku, on: :create

  def properties_config
    WebConfig.for("#{owner.class.table_name}.variants.properties")
  end

  def generate_sku
    self.sku = [
      owner.sku,
      options.keys.sort.map{|key| Sluggable.new(options[key]).to_slug.upcase }
    ].join('_')
  end
end
