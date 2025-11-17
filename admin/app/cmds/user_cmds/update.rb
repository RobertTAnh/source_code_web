module UserCmds
  class Update
    prepend BaseCmd
    include ::MediaCmds::Utils
    include ::Shared

    def initialize(context:, user:, params:, extra_params:)
      @context = context
      @user = user
      @params = params
      @extra_params = extra_params
    end

    def call
      validate
      update unless failure?
      assign_image_url
      output
    end

    private

    attr_reader :context, :params, :user, :extra_params

    def validate
      user.assign_attributes(params)

      return if user.valid?

      add_model_errors user
    end

    def update
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
