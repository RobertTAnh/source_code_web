module ProductCmds
  class Create
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::TagCmds::Utils

    def initialize(context:, params:)
      @context = context
      @params = params
    end

    def call
      validate
      create unless failure?
      assign_image_url
      output
    end

    private

    attr_reader :context, :params
    
    def product
      @product ||= Product.new(create_params)
    end

    def validate
      return if product.valid?

      add_model_errors product
    end

    def create
      product.save!
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link product.image.blob
        product.update image_url: image_url
      end
    end

    def output
      product
    end

    def create_params
      create_params_with_tags params
    end
  end
end
