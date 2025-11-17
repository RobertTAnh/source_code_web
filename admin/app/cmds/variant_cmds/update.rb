module VariantCmds
  class Update
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::Shared

    def initialize(context:, variant:, params:)
      @context = context
      @variant = variant
      @params = params
    end

    def call
      validate
      update
      assign_image_url
      output
    end

    private

    attr_reader :context, :params, :variant

    def validate
      variant.assign_attributes(params)

      return if variant.valid?

      add_model_errors variant
    end

        
    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link variant.image.blob
        variant.update image_url: image_url
      end
    end

    def update
      variant.save!
    end

    def output
      variant
    end
  end
end


