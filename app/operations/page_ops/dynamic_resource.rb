module PageOps
  class DynamicResource < BaseOperation
    def call
      validate_params

      get_resource

      prepare_data

      render_view
    end

    private

    attr_reader :resource

    def validate_params
    end

    def get_resource
      @resource = ::Resource.find_by slug: context.params[:slug]
    end

    def prepare_data
      context.instance_variable_set "@#{resource.class.name.underscore}", resource
      context.instance_variable_set '@content', resource.content
    end

    def render_view
      context.render_for resource
    end
  end
end
