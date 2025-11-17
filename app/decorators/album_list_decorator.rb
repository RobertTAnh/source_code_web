class AlbumListDecorator < BaseListDecorator
  set_item_class AlbumDecorator

  def by_slug(slug)
    wrap_list relation.by_slug(slug)
  end
end
