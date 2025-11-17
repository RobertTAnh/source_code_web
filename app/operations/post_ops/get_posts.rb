module PostOps
  class GetPosts < BaseOperation
    include CommonOperation::Paginatable

    def call
      get_posts
    end

    private

    def get_posts
      posts = []
      if context.params[:category_slug]
        category = Category.find_by slug: context.params[:category_slug]
        posts = category.posts.lastest
      else
        posts = Post.lastest
      end
      posts = paginate(posts).to_a
    end
  end
end