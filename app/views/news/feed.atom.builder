atom_feed do |feed|
  feed.title web_config('website.name')
  #feed.description web_config('website.description')
  feed.link root_url
  feed.image image_url(web_config("logo_url"))

  # latest_product = @product.products.sort_by(&:updated_at).last
  # feed.updated(latest_product && latest_product.updated_at)

  @posts.each do |post|
    feed.entry(post, :url =>  full_url_for_record(post)) do |entry|
      entry.title post.name
      #entry.url post_path(post)
      entry.description post.description
      entry.content post.content.body.to_s.html_safe
      entry.image image_url(post.image_url || '')
    end
  end

  @products.each do |product|
    feed.entry(product, :url => full_url_for_record(product)) do |entry|
      entry.title product.name
      #entry.link product.meta_data["link"]
      entry.description product.description
      entry.content product.content.body.to_s.html_safe
      entry.image image_url(product.image_url || '')
      entry.summary :type => 'xhtml' do |xhtml|
        xhtml.p product.description

        xhtml.table do
          xhtml.tr do
            xhtml.th 'Nhà sản xuất:'
            xhtml.th 'Mã sản xuất:'
            xhtml.th 'Bảo hành:'
            xhtml.th 'Giá bán:'
            xhtml.td product.name
            #xhtml.td product.code
            #xhtml.td product.guarantee
            xhtml.td product.price 
          end
        end
      end
    end
  end
  
end
