module HasProperties
  extend ActiveSupport::Concern

  class_methods do
    def properties_config
      WebConfig.for("#{table_name}.properties")
    end
  end

  def prop(name)
    properties&.dig(name, 'data')
  end

  included do
    before_save :get_key_from_data

    scope :has_prop, -> (key, value) { where("properties->'#{key}'->>'data' = ?", value) }
  end

  def get_key_from_data
    return unless properties_changed? && properties.present?
    self.properties.each do |key, value|
      value['key'] = Sluggable.new(value['data'].to_s).to_slug
    end
  end
end
