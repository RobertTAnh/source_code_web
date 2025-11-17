module SitemapHelper
  def self.query_resource_build(resource)
    data_resources = []

    if Object.const_defined?(resource["resource"])
      data_resources = resource["resource"].constantize.all
      if resource["scopes"].present?
        resource["scopes"].each do |scope|
          data_resources = data_resources.send(scope)
        end
      end

      if resource["where"].present?
        data_resources = data_resources.where(resource["where"])
      end

      if resource["where.not"].present?
        data_resources = data_resources.where.not(resource["where.not"])
      end

      if resource["orders"].present?
        data_resources = data_resources.order(resource["orders"])
      end

      data_resources
    end

    data_resources
  end
end

SitemapGenerator::Sitemap.default_host = ENV.fetch('HOST', 'http://localhost:3000')
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.create do
  if (sitemap_definition = WebConfig.for('sitemap.definition')).present?
    sitemap_definition["groups"].each do |sitemap|
      group(sitemaps_path: sitemap["sitemaps_path"], filename: sitemap["filename"]) do
        if (sitemap_paths = sitemap["paths"]).present?
          sitemap_paths.each do |path|
            add path["path"], changefreq: path["changefreq"], priority: path["priority"]
          end
        end

        if (sitemap_resources = sitemap["resources"]).present?
          sitemap_resources.each do |data_resource|
            if (query_resource_build = SitemapHelper.query_resource_build(data_resource)).present?
              query_resource_build.each do |resource|
                add RouteHelper::Methods.path_for(resource),
                    lastmod: resource.updated_at,
                    changefreq: data_resource["changefreq"],
                    priority: data_resource["priority"]
              end
            end
          end
        end
      end
    end

    next
  end

  group(sitemaps_path: 'sitemaps/', filename: 'sitemap_products') do
    add root_path,
        changefreq: 'daily',
        priority: 0.5

    if (paths = WebConfig.for('sitemap.add.products')).present?
      paths.each do |path|
        add path, changefreq: 'daily', priority: 0.5
      end
    end

    Product.published.order(updated_at: :desc).to_a.each do |product|
      add RouteHelper::Methods.path_for(product),
          lastmod: product.updated_at,
          changefreq: 'daily',
          priority: 0.5
    end
  end

  group(sitemaps_path: 'sitemaps/', filename: 'sitemap_posts') do
    if (paths = WebConfig.for('sitemap.add.posts')).present?
      paths.each do |path|
        add path, changefreq: 'daily', priority: 0.5
      end
    end

    Post.published.order(updated_at: :desc).to_a.each do |post|
      add RouteHelper::Methods.path_for(post),
          lastmod: post.updated_at,
          changefreq: 'daily',
          priority: 0.5
    end
  end

  group(sitemaps_path: 'sitemaps/', filename: 'sitemap_categories') do
    if (paths = WebConfig.for('sitemap.add.categories')).present?
      paths.each do |path|
        add path, changefreq: 'daily', priority: 0.5
      end
    end

    Category.published.not_post.order(depth: :asc, updated_at: :desc).to_a.each do |category|
      add RouteHelper::Methods.path_for(category),
          lastmod: category.updated_at,
          changefreq: 'daily',
          priority: 0.5
    end
  end

  group(sitemaps_path: 'sitemaps/', filename: 'sitemap_pages') do
    if (paths = WebConfig.for('sitemap.add.pages')).present?
      paths.each do |path|
        add path, changefreq: 'daily', priority: 0.5
      end
    end

    Page.published.seo_index.where.not(slug: '/').order(updated_at: :desc).to_a.each do |page|
      add RouteHelper::Methods.path_for(page),
          changefreq: 'daily',
          priority: 0.5
    end
  end
end
