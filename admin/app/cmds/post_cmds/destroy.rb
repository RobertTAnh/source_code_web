module PostCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, post:)
      @context = context
      @post = post
    end

    def call
      validate
      destroy_post unless failure?
      output
    end

    private

    attr_reader :context, :post

    def validate
    end

    def destroy_post
      post.discard!
    end

    def output
      post
    end
  end
end


