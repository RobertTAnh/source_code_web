class Api::ApiController < ApplicationController
  def general_search
    html = Theme.current.render_view("components/search/search_list",
      self,
      locals: {
        results: SearchOps::GeneralSearch.new(self, should_render: false).call
      }
    )
    render inline: html
  end

  def get_posts
    html = Theme.current.render_view("components/posts/posts_list",
      self,
      locals: {
        posts: PostOps::GetPosts.new(self).call
      }
    )
    render inline: html
  end

  def get_products
    html = Theme.current.render_view("components/products/products_list",
      self,
      locals: {
        products: ProductOps::GetProducts.new(self).call
      }
    )
    render inline: html
  end
end