# Define model for custom resources
WebConfig.custom_resource_config.each do |resource|
  Object.send(:remove_const, resource[:name]) if Object.const_defined?(resource[:name])

  eval <<DYNAMIC
    class #{resource[:name]} < Resource
      #{resource[:has_slug] ? 'include HasSlug' : ''}
      #{resource[:has_slug] ? 'include HasGlobalSlug' : ''}
      #{resource[:has_category] ? 'include HasCategories' : ''}

      def self.polymorphic_name
        '#{resource[:name]}'
      end
    end
DYNAMIC
end

# Define admin controller for custom resources
module Admin
  WebConfig.custom_resource_config.each do |resource|
  controller_name = "#{resource[:name].pluralize}Controller"

  Admin.send(:remove_const, controller_name) if Admin.const_defined?(controller_name)

  eval <<DYNAMIC
    class #{controller_name} < ResourcesController
    end
DYNAMIC
  end
end
