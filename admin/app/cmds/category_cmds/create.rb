module CategoryCmds
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
    
    def category
      @category ||= Category.new(create_params)
    end

    def calculate_depth
      if category.parent
        category.parent.depth + 1
      else
        1
      end
    end

    def validate
      return if category.valid?

      add_model_errors category
    end

    def create
      category.depth = calculate_depth
      category.save!
    end

    def output
      category
    end

    def create_params
      create_params_with_tags params
    end
  end
end
