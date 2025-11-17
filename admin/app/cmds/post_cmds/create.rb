module PostCmds
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

    def post 
      @post ||= Post.new(create_params)
    end

    def validate
      return if post.valid?

      add_model_errors post
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link post.image.blob
        post.update image_url: image_url
      end
    end

    def create
      post.save! 
    end

    def output
      post
    end

    def create_params
      create_params_with_tags params
    end
  end
end
