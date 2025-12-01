module RoleCmds
  class GrantUserToRole
    prepend BaseCmd

    def initialize(context:, params:)
      @context = context
      @params = params
    end

    def call
      validate
      create unless failure?
      clear_cache
      output
    end

    private

    attr_reader :context, :params
    
    def role
      @role ||= Role.find_by_id(params[:role_id])
    end

    def validate
      unless role
        errors.add('base', "Role not found.")
      end
    end

    def clear_cache
      Role.clear_cache
    end

    def create
      @new_user_roles = []
      params[:user_id].each do |id|
        new_user_role = role.user_roles.new(user_id: id)
        if new_user_role.valid?
          new_user_role.save
          @new_user_roles << new_user_role
        end
      end
    end

    def output
      @new_user_roles
    end
  end
end

