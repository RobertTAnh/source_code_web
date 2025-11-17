class CartController < ApplicationController
  def show
    @theme_option_seo_noindex = true
    PageOps::Cart.new(self).call
  end
end
