module ProductCmds
  class Update
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::Shared
    include ::TagCmds::Utils

    def initialize(context:, product:, params:, extra_params:)
      @context = context
      @product = product
      @params = params
      @extra_params = extra_params
      @html_processor = ::CustomHtmlCmds::Process.new(obj: product, extra_params: extra_params)
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

    attr_reader :context, :params, :product, :extra_params, :html_processor

    def validate
      product.assign_attributes(edit_params)

      if !html_processor.valid?
        errors.add(:base, "Custom HTML file must be a html file!")
      end

      return if product.valid?

      add_model_errors product
    end

    def process_custom_html
      html_processor.process
    end

    def update
      product.save!
      update_category product
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link product.image.blob
        product.update image_url: image_url
      end

      if params["content_attributes"]["meta_image"]
        meta_image_url = get_relative_direct_link product.content.meta_image.blob
        product.content.update meta_image_url: meta_image_url
      end
    end

    def output
      product
    end

    def edit_params
      update_params_with_tags product, params
    end
  end
end
