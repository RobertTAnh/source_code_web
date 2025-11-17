module MetaTagsHelper
  def all_meta_tags
    default_meta_tags + 
    googlebot_meta_tags + 
    locale_meta_tags + 
    seo_meta_tags +
    custom_meta_tags
  end

  def default_meta_tags
    [
      { :content => "text/html; charset=UTF-8", "http-equiv" => "Content-Type" },
      { :content => "width=device-width, initial-scale=1.0", :name => "viewport" }
    ]
  end

  def googlebot_meta_tags
    if seo_index?
      [
        { content: 'index, follow', name: 'robots' },
        { content: 'index, follow', name: 'googlebot-news' },
        { content: 'index, follow', name: 'googlebot' },
        { content: 'snippet', name: 'googlebot-news' }
      ]
    else
      [
        { :content =>  "noindex, nofollow", :name => "robots" },
        { :content =>  "noindex, nofollow", :name => "googlebot-news" },
        { :content =>  "noindex, nofollow", :name => "googlebot" },
        { :content => "nosnippet", :name => "googlebot-news" }
      ]
    end
  end

  def locale_meta_tags
    [
      {:charset => "ISO-8859-1″", :content => "text/html;", "http-equiv" => "Content-Type"},
      {:content => "Vietnamese", "http-equiv" => "content-language"},
      {:content => "vi", "http-equiv" => "Content-Language"},
      {:content => "vn", :name => "Language"}
    ]
  end

  def geo_meta_tags
    [
      {:content => "VN-HN", :name => "geo.region"},
      {:content => "Hà Nội", :name => "geo.placename"},
      {:content => "21.024813;105.853297", :name => "geo.position"},
      {:content => "21.024813, 105.853297", :name => "ICBM"}
    ]
  end

  def seo_meta_tags
    [
      {:content => "website", :property => "og:type"},
      {:content => meta_description, :name => "description"},
      {:content => meta_title, :name => "title"},
      {:content => meta_link, :name => "url"},
      {:content => meta_image, :name => "image"},
      {:content => meta_link, :property => "og:url"},
      {:content => meta_image, :property => "og:image"},
      {:content => meta_title, :property => "og:image:alt"},
      {:content => meta_title, :property => "og:title"},
      {:content => meta_description, :property => "og:description"},
      {:content => meta_description, :name => "Abstract"}
    ]
  end

  def custom_meta_tags
    WebConfig.for('seo.meta_tags') || []
  end

  def seo_index?
    return false if @theme_option_seo_noindex

    web_config('seo.index_all') && meta_content.seo_index?
  end

  def meta_content
    @meta_content ||= (content || Page.home.content)
  end

  def meta_content_owner
    @meta_content_owner ||= meta_content.owner
  end

  def meta_description
    safe_eval_user_input(
      meta_content.meta_description.presence || meta_content_owner.description.presence
    )    
  end

  def meta_title
    safe_eval_user_input(
      meta_content.meta_title.presence || meta_content_owner.name.presence
    )    
  end

  def meta_image
    meta_content.meta_image_url.present? ? full_asset_url(meta_content.meta_image_url) : full_asset_url(meta_content_owner.image_url)
  end

  def meta_link
    full_asset_url path_for(meta_content_owner)
  end

  def canonical_url
    full_url_for_record meta_content_owner
  end
end
