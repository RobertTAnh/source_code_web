module UserCmds
  class Create
    prepend BaseCmd
    include ::MediaCmds::Utils

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
    
    def user
      @user ||= User.new(params)
    end

    def validate
      return if user.valid?

      add_model_errors user
    end

    def create
      user.save!
    end

    def assign_image_url
      if params[:image]
        image_url = get_relative_direct_link user.image.blob
        user.update image_url: image_url
      end
    end

    def output
      user
    end
  end
end
