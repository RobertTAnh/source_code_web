class PaymentController < ApplicationController
  def show
    @theme_option_seo_noindex = true
    render_for 'payment'
  end

  def dopayment_vexere
    render_for 'dopayment_vexere'
  end
end
