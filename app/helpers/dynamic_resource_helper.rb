module DynamicResourceHelper
  WebConfig.custom_resource_config.each do |resource|
    # Example usage: get_policies
    define_method "get_#{resource[:name].underscore.pluralize}" do
      resource[:name].constantize.all
    end

    # Example usage: policy
    define_method "#{resource[:name].underscore}" do
      instance_variable_get "@#{resource[:name].underscore}"
    end
  end
end
