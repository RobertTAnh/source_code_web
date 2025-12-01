class PagesController < ApplicationController
  before_action :redirect_to_slash, except: :slug
  before_action :redirect_to_primary, except: :home

  include ActionCachable

  if Settings.page_caching_enabled?
    caches_page :home, :page, :category, :product, :post
    page_cache_directory = -> { Settings.page_caching_directory }
  end

  def home
    params[:page] = '/'

    PageOps::Page.new(self).call
  end

  def page
    PageOps::Page.new(self).call
  end

  def category
    PageOps::Category.new(self).call
  end

  def product
    PageOps::Product.new(self).call

    add_viewed_products
  end

  def post
    PageOps::Post.new(self).call
  end

  def resource
    PageOps::DynamicResource.new(self).call
  end

  # Handle custom url redirecting, especially for redirecting legacy url to new url
  # It should be redirected by `before_action :redirect_to_slash`, so don't need to handle it here
  def slug; end

  private

  def redirect_to_slash
    return if request.original_fullpath.split('?', 2).first.end_with?('/')

    path = request.path + '/'
    path += '?' + request.query_string if request.query_string.present?

    redirect_to path, status: :moved_permanently
  end

  def redirect_to_primary
    global_slug = RequestStore.store[:current_global_slug]

    render_not_found if global_slug.sluggable.status == 'unpublished'

    return if global_slug.primary?

    if primary_slug = global_slug.get_primary
      return redirect_to "#{path_for(primary_slug.sluggable)}#{request.query_string.present? ? "?#{request.query_string}" : ""}", status: :moved_permanently
    end

    render_not_found
  end

  def add_viewed_products
    return unless @product

    viewed_ids = cookies[:viewed_products].present? ? JSON.parse(cookies[:viewed_products]) : []

    viewed_ids.unshift(@product.id)
    viewed_ids.pop(viewed_ids.size - 10) if viewed_ids.size > 10

    cookies[:viewed_products] = JSON.dump(viewed_ids.uniq)
  end
end
