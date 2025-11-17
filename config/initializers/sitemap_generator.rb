require 'sitemap_generator'

# Override SitemapGenerator::Sitemap.ping_search_engines to only ping google when index is on
module SitemapGenerator
  class LinkSet

    alias_method :original_ping_search_engines, :ping_search_engines

    def ping_search_engines(*args)
      unless WebConfig.for('seo.index_all')
        output('Skip pinging sitemap because seo index is off')
        return
      end

      original_ping_search_engines(*args)
    end
  end
end
