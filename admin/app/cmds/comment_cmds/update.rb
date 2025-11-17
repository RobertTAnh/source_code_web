module CommentCmds
  class Update
    prepend BaseCmd

    def initialize(context:, params:, comment:)
      @context = context
      @params = params
      @comment = comment
    end

    def call
      validate
      update
      output
    end

    private

    attr_reader :comment, :context, :params
    
    def validate
    end

    def update
      comment.update(params)
    end

    def output
      comment
    end
  end
end
