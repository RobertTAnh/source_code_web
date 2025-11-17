module PostHelper
  def lastest_posts
    @lastest_posts ||= Post.lastest
  end

  def favorite_posts
    @favorite_posts ||= Post.favorite
  end

  def popular_posts
    @popular_posts ||= Post.popular
  end
end
