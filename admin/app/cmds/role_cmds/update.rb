module RoleCmds
  class Update
    prepend BaseCmd

    def initialize(context:, role:, params:)
      @context = context
      @role = role
      @params = params
    end

    def call
      validate
      update unless failure?
      clear_cache
      output
    end

    private

    attr_reader :context, :params, :role

    def validate
      role.assign_attributes(params)

      return if role.valid?

      add_model_errors role
    end

    def clear_cache
      Role.clear_cache
    end

    def update
      role.save!
    end

    def output
      role
    end
  end
end
