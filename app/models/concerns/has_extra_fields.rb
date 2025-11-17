module HasExtraFields
  extend ActiveSupport::Concern

  included do
    has_many :extra_fields, as: :owner, dependent: :destroy
    accepts_nested_attributes_for :extra_fields

    class << self
      def extra_fields_by_config
        WebConfig.for("#{table_name}.extra_fields")
      end
    end
  end

  # TODO: auto format value based on extra_field definition
  def extra_field(key)
    extra_fields_by_key[key]
  end

  def extra_fields_by_key
    @extra_fields_by_key ||= self.extra_fields.index_by(&:key)
  end
end
