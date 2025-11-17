module PageOps
  class Post < BaseOperation
    def call
      validate_params

      get_post

      prepare_data

      increment_view_count
      
      render_view
    end

    private

    attr_reader :post

    def validate_params
    end

    def get_post
      @post = ::Post.find_by(slug: context.params[:post])
    end

    def prepare_data
      context.instance_variable_set '@post', post
      context.instance_variable_set '@content', post.content
    end

    def increment_view_count
      @post.increment!(:view_count)
    end

    def render_view
      context.render_for post
    end
  end
end
