module PostCmds
  class Update
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::Shared
    include ::TagCmds::Utils

    def initialize(context:, post:, params:, extra_params:)
      @context = context
      @post = post
      @params = params
      @extra_params = extra_params
      @html_processor = ::CustomHtmlCmds::Process.new(obj: post, extra_params: extra_params)
    end

    def call
      convert_extra_fields_data
      validate
      update unless failure?
      assign_image_url
      process_custom_html
      output
    end

    private

    attr_reader :context, :params, :post, :extra_params, :html_processor

    def validate
      post.assign_attributes(update_params)

      if !html_processor.valid?
        errors.add(:base, "Custom HTML file must be a html file!")
      end

      return if post.valid?

      add_model_errors post
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link post.image.blob
        post.update image_url: image_url
      end

      if params["content_attributes"]["meta_image"]
        meta_image_url = get_relative_direct_link post.content.meta_image.blob
        post.content.update meta_image_url: meta_image_url
      end
    end

    def process_custom_html
      html_processor.process
    end

    def update
      post.save!
      update_category post
    end

    def output
      post
    end

    def update_params
      update_params_with_tags post, params
    end
  end
end

