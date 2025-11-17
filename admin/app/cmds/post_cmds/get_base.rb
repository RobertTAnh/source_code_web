module PostCmds
  class GetBase
    def initialize(context:, params:)
      @context = context
      @params = params
    end

    def call
      fail NotImplementedError
    end

    private

    attr_reader :context, :params

    def validate_params!
    end
  end
end
