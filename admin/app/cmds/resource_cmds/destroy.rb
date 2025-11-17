module ResourceCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, resource:)
      @context = context
      @resource = resource
    end

    def call
      validate
      destroy_resource unless failure?
      output
    end

    private

    attr_reader :context, :resource

    def validate
    end

    def destroy_resource
      resource.discard!
    end

    def output
      resource
    end
  end
end
