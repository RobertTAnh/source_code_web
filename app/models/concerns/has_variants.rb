module HasVariants
  extend ActiveSupport::Concern

  included do
    has_many :variants, as: :owner, dependent: :destroy
    before_save :add_key_name_options
    after_save :update_variants
  end

  def update_variants
    update_variant_name if name_previously_changed?
    update_variant_sku if self.respond_to?("sku_previously_changed?") && sku_previously_changed?

    if variant_options_previously_changed?
      options = variant_options || []
      options.each do |option|
        option['key'] = Sluggable.new(option['name'].to_s).to_slug
      end

      if options.blank?
        self.variants.delete_all
        return 
      end

      options = options.sort_by{|option| option['name']}
      variant_options = [{'name' => self.name, 'option' => {}}]
      variant_names = []

      options.each do |option|
        values = option['values']
        next if values.empty?

        variant_options = create_variant(variant_options, option)
      end

      variant_names = variant_options.pluck('name')
      variant_options_hashed = variant_options.map{|val| [val['name'], val['option']]}.to_h
      db_variants = self.variants
      db_variant_names = db_variants.pluck(:name)
      variant_names_will_delete = db_variant_names - variant_names
      self.variants.where(name: variant_names_will_delete).delete_all
      variant_names_will_add = variant_names - db_variant_names
      variant_data = []

      variant_names_will_add.each.with_index do |variant_name|
        variants.create!({
          name: variant_name,
          options: variant_options_hashed[variant_name]
        })
      end
    end
  end

  private
    def update_variant_name
      variants.each do |variant|
        variant.name = variant.name.gsub(name_was, name)
        variant.save!
      end
    end

    def update_variant_sku
      variants.each do |variant|
        variant.sku = variant.sku.gsub(sku_was, sku)
        variant.save!
      end
    end

    def create_variant(option_names, option_values)
      data = []

      option_names.each do |option_name|
        option_values['values'].each do |option_value|
          name = option_name['name'] + '-' + option_value
          option = option_name['option']
          new_option = {}
          new_option[option_values['key']] = option_value

          data << {
            'name' => name,
            'option' => option.merge(new_option)
          }
        end
      end

      data
    end

    def add_key_name_options
      return unless variant_options_changed? && variant_options.present?
      options_was = variant_options_was || []
      self.variant_options = variant_options.select do |option|
        option["name"].present? && option["values"].map{|value| value.presence}.compact.present?
      end

      variant_options.each do |option|
        option["key"] = Sluggable.new(option["name"].to_s).to_slug
        option["values"] = option["values"].map{|value| value.presence}.compact
      end
    end
end
