module UserCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, user:)
      @context = context
      @user = user
    end

    def call
      validate
      destroy_user unless failure?
      output
    end

    private

    attr_reader :context, :user

    def validate
    end

    def destroy_user
      user.destroy!
    end

    def output
      user
    end
  end
end

