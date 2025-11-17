module Admin
  module DynamicResourceHelper
    def resources_url resource_name, *args
      send("#{resource_name.pluralize}_url", *args)
    end

    def edit_resource_url resource_name, resource_record, *args
      send("edit_#{resource_name}_url", resource_record, *args)
    end

    def resources_path resource_name, *args
      send("#{resource_name.pluralize}_path", *args)
    end

    def edit_resource_path resource_name, resource_record, *args
      send("edit_#{resource_name}_path", resource_record, *args)
    end

    def get_resource_config_for resource_name
      WebConfig.custom_resource_config.find{|config| config[:name] == resource_name}
    end
  end
end
