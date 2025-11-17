module PageCmds
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
      output
    end 

    private

    attr_reader :context, :params

    def page
      @page ||= Page.new(create_params)
    end

    def validate
      return if page.valid?

      add_model_errors page
    end

    def create
      page.save!
    end

    def output
      page
    end

    def create_params
      create_params_with_tags params
    end
  end
end
