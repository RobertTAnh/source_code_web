module ResourceCmds
  class Create
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::TagCmds::Utils

    def initialize(context:, params:, resource:)
      @context = context
      @params = params
      @resource = resource
    end

    def call
      validate
      create unless failure?
      assign_image_url
      output
    end 

    private

    attr_reader :context, :params

    def new_resource
      @new_resource ||= @resource.new(create_params)
    end

    def validate
      return if new_resource.valid?

      add_model_errors new_resource
    end

    def create
      new_resource.save!
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link new_resource.image.blob
        new_resource.update image_url: image_url
      end
    end

    def output
      new_resource
    end

    def create_params
      create_params_with_tags params
    end
  end
end
