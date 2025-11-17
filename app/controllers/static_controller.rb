class StaticController < ActionController::Base
  caches_page :robots
  page_cache_directory = -> { Rails.public_path }

  def robots
    render 'static/robots', layout: false, content_type: 'text/plain'
  end
end
