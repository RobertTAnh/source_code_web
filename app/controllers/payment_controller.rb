class PaymentController < ApplicationController
  def show
    @theme_option_seo_noindex = true
    render_for 'payment'
  end
end
