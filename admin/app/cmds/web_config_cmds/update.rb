module WebConfigCmds
  class Update
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::Shared

    def initialize(context:, web_config:, params:, extra_params:)
      @context = context
      @web_config = WebConfig.find(web_config.id) # reload web config to avoid error when saving
      @params = params
      @extra_params = extra_params
    end

    def call
      convert_extra_fields_data
      validate
      update unless failure?
      create_permissions
      output
    end

    private

    attr_reader :context, :params, :web_config, :extra_params

    def validate
      web_config.assign_attributes(params)

      return if web_config.valid?

      add_model_errors web_config
    end

    def update
      web_config.save!
    end

    def create_permissions
      permissions = {}

      WebConfig.custom_resource_config.each do |cfg|
        permissions[cfg[:name]] =  ["create", "read", "update", "delete", "*"]
      end

      permissions.each do |grant_on, actions|
        actions.each do |action|
          next if Permission.where(name: action, granted_on: grant_on).exists?

          Permission.create!(name: action, granted_on: grant_on)
        end
      end
    end

    def output
      web_config
    end
  end
end

