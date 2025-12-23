class WebConfig < ApplicationRecord
  LOGGABLE_RELATIONS = %w|extra_fields|

  include HasExtraFields
  after_save -> { WebConfig.reload }

  def add_string(key, data)
    add(key: key, data: data, data_type: ExtraField.data_types[:string])
  end

  def add_image(key, data)
    add(key: key, data: data, data_type: ExtraField.data_types[:image])
  end

  def add_text(key, data)
    add(key: key, data: data, data_type: ExtraField.data_types[:text])
  end

  def add_json(key, data)
    add(key: key, data: data, data_type: ExtraField.data_types[:json])
  end

  def add_boolean(key, data)
    add(key: key, data: data, data_type: ExtraField.data_types[:boolean])
  end

  def add(key:, data:, data_type:)
    if extra_field = extra_fields.find_by(key: key)
      extra_field.update!(data: data, data_type: data_type)
      extra_field
    else
      extra_fields.create!(key: key, data: data, data_type: data_type)
    end
  end

  class << self
    def current
      @current ||= WebConfig.first
    rescue ActiveRecord::ConnectionNotEstablished, PG::ConnectionBad
      nil
    end

    def for(key)
      key = key.to_s

      hash_config[key].presence || theme_web_configs[key].presence || default_config_for(key)
    end

    # Get config and convert to constant
    def for_constant(key, default = nil)
      value = self.for(key)
      value.present? ? value.constantize : default
    end

    def default_config_for(key)
      DEFAULT_CONFIG[key]
    end

    def theme_web_configs
      return {} unless Theme.current

      @theme_web_configs ||= Theme.current.config['web_configs'] || {}
    end

    def hash_config
      @hash_config ||= all_config.pluck(:key, :data).to_h
    end

    def all_config
      @all_config ||= load_all
    end

    def reload
      @all_config = load_all
      @hash_config = all_config.pluck(:key, :data).to_h
    end

    def load_all
      WebConfig.current ? ExtraField.where(owner: WebConfig.current).to_a : []
    # Handle missing table error when run db:migrate for the first time,
    # because web config is accessed in routes
    rescue ActiveRecord::NoDatabaseError
      []
    rescue ActiveRecord::ConnectionNotEstablished, PG::ConnectionBad
      []
    rescue ActiveRecord::StatementInvalid => e
      if e.message.match(/relation "web_configs" does not exist/)
        []
      else
        raise e
      end
    end

    # TODO: deprecated, should remove
    def build_route(route_name, params)
      route = self.for(route_name)
      params.each do |key, value|
        route = route.gsub(/[:\*]#{key}/, value)
      end

      route
    end

    # TODO: deprecated, should remove
    def build_resource_route(resource_name, params)
      resource_config = resource_config_for resource_name
      route = resource_config && resource_config[:route]
      route = '/:slug' unless route
      params.each do |key, value|
        route = route.gsub(/[:\*]#{key}/, value)
      end

      route
    end

    def custom_resource_config
      (self.for("website.resources") || []).map do |resource_config|
        resource_config.deep_symbolize_keys
      end
    end

    def resource_config_for resource_name
      custom_resource_config.find{|resource| resource[:name] == resource_name}
    end

    def additional_categories_for config = 'all'
      if config == 'all'
        # TODO: have better way to check
        (WebConfig.for("features") || {}).select{|key, value| value.is_a?(Hash) && value['additional_categories']}.values.pluck("additional_categories").flatten
      else
        (WebConfig.for("features") || {}).dig(config, "additional_categories")
      end
    end
  end

  DEFAULT_CONFIG = {
    'routes.page'     => '/*page',
    'routes.category' => '/:category',
    'routes.product'  => '/:product',
    'routes.post'     => '/:post',

    'paging.page_size' => 12,
    'admin.contacts_list.display_fields' => %i[name phone email form note created_at],

    'menus' => {
      items: [
        {
          title: 'Categories',
          children: [
            {
              target: 'category',
              title: 'Category 1',
              slug: 'category_1'
            },
            {
              target: 'category',
              title: 'Category 2',
              slug: 'category_2'
            }
          ]
        },
        {
          target: 'page',
          title: 'About',
          slug: 'about'
        }
      ]
    }
  }
end
