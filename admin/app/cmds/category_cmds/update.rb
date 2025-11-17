module CategoryCmds
  class Update
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::Shared
    include ::TagCmds::Utils

    def initialize(context:, category:, params:)
      @context = context
      @category = category
      @params = params
    end

    def call
      convert_extra_fields_data
      validate
      update unless failure?
      assign_image_url
      output
    end

    private

    attr_reader :context, :params, :category

    def validate
      category.assign_attributes(update_params)

      return if category.valid?

      add_model_errors category
    end

    def calculate_depth
      if category.parent
        category.parent.depth + 1
      else
        1
      end
    end

    def update
      category.depth = calculate_depth
      category.save!
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link category.image.blob
        category.update image_url: image_url
      end

      if params["content_attributes"]["meta_image"]
        meta_image_url = get_relative_direct_link category.content.meta_image.blob
        category.content.update meta_image_url: meta_image_url
      end
    end

    def output
      category
    end

    def update_params
      update_params_with_tags category, params
    end
  end
end
