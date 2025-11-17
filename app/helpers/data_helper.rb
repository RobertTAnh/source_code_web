module DataHelper
  def slogan
    'This is slogan'
  end

  def website
    @website ||= get_website
  end

  def theme
    @theme ||= website.theme
  end

  def post
    @post
  end

  def product
    @product
  end

  def category
    @category
  end

  def page
    @page
  end

  def menu
    @menu ||= get_menu
  end

  def products
    @products
  end

  def posts
    @posts
  end

  def content
    @content
  end

  def featured_products
    @featured_products ||= ProductOps::GetFeaturedProducts.new(context: self).call
  end
end
