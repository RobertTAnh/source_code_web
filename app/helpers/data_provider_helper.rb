module DataProviderHelper
  # Return all published products
  def get_products
    Product.published.default_sort
  end

  def get_posts
    Post.published.default_sort
  end

  def get_categories
    Category.root.published.default_sort
  end

  def get_category_by_slug(slug)
    Category.published.where(slug: slug).first
  end

  def get_albums
    AlbumListDecorator.new Album.where(owner: nil)
  end

  def get_category_posts(slug)
    CategoryOps::GetCategories.new(self,slug).call
  end
end
