module CommentCmds
  class Create
    prepend BaseCmd

    def initialize(context:, params:, parent:)
      @context = context
      @params = params
      @parent = parent
    end

    def call
      validate
      assign_default_field
      create
      output
    end

    private

    attr_reader :context, :params
    
    def comment
      @comment ||= Comment.new(params)
    end

    def validate
    end

    def create
      comment.save!
    end

    def assign_default_field
      depth = @parent.depth ? @parent.depth : 0
      comment.depth = depth + 1
      comment.parent = @parent
      comment.status = 'published'
      comment.is_admin = true
    end

    def output
      comment
    end
  end
end
