module ResourceCmds
  class Update
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::Shared
    include ::TagCmds::Utils

    def initialize(context:, resource:, params:, extra_params:)
      @context = context
      @resource = resource
      @params = params
      @extra_params = extra_params
      @html_processor = ::CustomHtmlCmds::Process.new(obj: resource, extra_params: extra_params)
    end

    def call
      convert_extra_fields_data
      validate
      unless failure?
        update
        assign_image_url
        process_custom_html
      end
      output
    end

    private

    attr_reader :context, :params, :resource, :extra_params, :html_processor

    def validate
      resource.assign_attributes(update_params)

      if !html_processor.valid?
        errors.add(:base, "Custom HTML file must be a html file!")
      end

      return if resource.valid?

      add_model_errors resource
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link resource.image.blob
        resource.update image_url: image_url
      end

      if params.dig("content_attributes", "meta_image")
        meta_image_url = get_relative_direct_link resource.content.meta_image.blob
        resource.content.update meta_image_url: meta_image_url
      end
    end

    def process_custom_html
      html_processor.process
    end

    def update
      resource.save!
      update_category resource
    end

    def output
      resource
    end

    def update_params
      update_params_with_tags resource, params
    end
  end
end
