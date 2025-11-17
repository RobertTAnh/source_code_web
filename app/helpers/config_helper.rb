module ConfigHelper
  def web_config(key)
    WebConfig.for(key.to_s)
  end

  # TODO: this help override rails config, need to remove soon
  if ENV['ASSET_HOST'].blank?
    def config(key)
      WebConfig.for(key.to_s)
    end
  end

  def menus
    @menus ||= WebConfig.for('menus')
  end

  def menu_item_href(item)
    case item[:target]
    when 'category'
      category_path(item[:slug])
    when 'page'
      page_path(item[:slug])
    when 'product'
      product_path(item[:slug])
    else
      '#'
    end
  end
end
