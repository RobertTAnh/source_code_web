
Rails.application.routes.draw do
  mount Admin::Engine => "/admin"
  def with_locale_scope(&block)
    if Settings.localized?
      scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/, &block
    else
      yield
    end
  end

  resources :contacts, only: %i(create)
  resources :cart_items, only: %i(create update destroy)
  resource :cart, only: %i(show), controller: :cart
  resources :orders, only: %i(create show)
  resource :payment, only: %i(show), controller: :payment
  resource :search, only: %i(show), controller: :search
  resources :comments, only: %i(index create)

  get 'api/general_search', to: 'api/api#general_search'
  get 'api/get_posts', to: 'api/api#get_posts'
  get 'api/get_products', to: 'api/api#get_products'

  get 'feed', to: 'news#feed'

  with_locale_scope do
    root 'pages#home'

    get WebConfig.for('routes.category'), to: 'pages#category', as: :category, constraints: WebConfig.for_constant('routes.category.constraints', CategoryConstraint)
    get WebConfig.for('routes.product'), to: 'pages#product', as: :product, constraints: WebConfig.for_constant('routes.product.constraints', ProductConstraint)
    get WebConfig.for('routes.post'), to: 'pages#post', as: :post, constraints: WebConfig.for_constant('routes.post.constraints', PostConstraint)

    get WebConfig.for('routes.page'), to: 'pages#page', as: :page, constraints: WebConfig.for_constant('routes.page.constraints', PageConstraint)

    WebConfig.custom_resource_config.each do |resource|
      next unless resource[:has_slug]

      get resource[:route] || '/:slug', to: "pages#resource", as: resource[:name].underscore, constraints: ResourceConstraint[resource[:name]]
    end

    (WebConfig.for('routes.custom') || []).each do |custom_route|
      method = custom_route['method'].presence || 'get'

      raise "Invalid custom route method: #{method}" unless  %w(get post).include?(method)

      params = custom_route['params'].present? ? custom_route['params'].symbolize_keys : {}

      if custom_route['constraints'].present?
        params[:constraints] = custom_route['constraints'].constantize
      end

      send method.to_sym, custom_route['path'], **params
    end

    # Full slug redirecting
    get '*slug', to: 'pages#slug', constraints: SlugConstraint
  end

  get 'robots.txt', to: 'static#robots'

  if ENV.fetch('SERVE_LEGACY_ASSETS', false)
    get '/uploads/*path', to: 'dev#uploads'
  end

  with_locale_scope do
    get '*404', to: 'application#render_not_found', constraints: HtmlFormatConstraint
  end
end
