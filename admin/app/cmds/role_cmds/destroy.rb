module RoleCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, role:)
      @context = context
      @role = role
    end

    def call
      validate
      destroy_role unless failure?
      clear_cache
      output
    end

    private

    attr_reader :context, :role

    def validate
    end

    def destroy_role
      role.destroy!
    end

    def clear_cache
      Role.clear_cache
    end

    def output
      role
    end
  end
end

