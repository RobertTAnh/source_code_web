module PostCmds
  class Show < GetBase
    prepend BaseCmd

    def call
      step :validate_params!
      step :load_post
    end

    def load_post
      post = Post.find_by(id: params[:id])
    end
  end
end
