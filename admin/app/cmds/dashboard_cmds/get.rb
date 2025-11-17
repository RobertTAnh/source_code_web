module DashboardCmds
  class Get
    prepend BaseCmd

    def call
      {
        products: Product.count,
        contacts: Contact.count,
        posts: {
          total: Post.count,
          published: Post.published.count,
          unpublished: Post.unpublished.count,
          this_month: Post.where("created_at >= ?", Time.now.beginning_of_month).count,
          this_week: Post.where("created_at >= ?", Time.now.beginning_of_week).count,
        }
      }
    end
  end
end
