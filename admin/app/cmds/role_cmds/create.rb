module RoleCmds
  class Create
    prepend BaseCmd

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
    
    def role
      @role ||= Role.new(params)
    end

    def validate
      return if role.valid?

      add_model_errors role
    end

    def create
      role.save!
    end

    def output
      role
    end
  end
end
