module PageCmds
  class Update
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::Shared
    include ::TagCmds::Utils

    def initialize(context:, page:, params:, extra_params:)
      @context = context
      @page = page
      @params = params
      @extra_params = extra_params
      @html_processor = ::CustomHtmlCmds::Process.new(obj: page, extra_params: extra_params)
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

    attr_reader :context, :params, :page, :extra_params, :html_processor

    def validate
      page.assign_attributes(update_params)

      if !html_processor.valid?
        errors.add(:base, "Custom HTML file must be a html file!")
      end

      return if page.valid?

      add_model_errors page
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link page.image.blob
        page.update image_url: image_url
      end

      if params["content_attributes"]["meta_image"]
        meta_image_url = get_relative_direct_link page.content.meta_image.blob
        page.content.update meta_image_url: meta_image_url
      end
    end

    def process_custom_html
      html_processor.process
    end

    def update
      page.save!
    end

    def output
      page
    end

    def update_params
      update_params_with_tags page, params
    end
  end
end

