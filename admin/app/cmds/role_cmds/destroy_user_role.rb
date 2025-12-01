module RoleCmds
  class DestroyUserRole
    prepend BaseCmd

    def initialize(context:, user_role:)
      @context = context
      @user_role = user_role
    end

    def call
      validate
      destroy_user_role unless failure?
      clear_cache
      output
    end

    private

    attr_reader :context, :user_role

    def validate
    end

    def clear_cache
      Role.clear_cache user_role.user_id
    end

    def destroy_user_role
      user_role.destroy!
    end

    def output
      user_role
    end
  end
end


