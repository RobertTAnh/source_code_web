# TODO: move to logic to command
class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if params[:draft]
      create_draft_order
    elsif params[:direct_buy]
      create_direct_buy_order
    else
      update_order
    end
  end

  def show
    @theme_option_seo_noindex = true
    @order = Order.where(customer_uuid: customer_uuid).where(code: params[:id]).first

    render_for 'order_tracking'
  end

  private

  def update_order
    redirect_to root_path unless draft_order

    draft_order.update!({
      status: 'created',
      vat_fee: update_params[:invoice_required] ? VatFee.get : nil
    }.merge(update_params))

    CartItem.where(order_id: draft_order.id).destroy_all

    NotifierMailer.order_created(draft_order).deliver_later if Settings.email_notification_enabled?

    render json: {
      data: draft_order.as_json(except: %i[id]),
      tracking: order_path(draft_order.code)
    }, status: :ok
  end

  # TODO: get price by variant from server
  def create_direct_buy_order
    data = params.permit(:product_id, :price, :variants, :variant_id)

    @order_item = OrderItem.new(
      product_id: params[:product_id],
      quantity: params[:quantity],
      original_price: params[:original_price],
      price: params[:price],
      variant_id: params[:variant_id],
      variants: params[:variants]
    )

    @order = Order.new(
      customer_uuid: customer_uuid,
      status: 'draft',
      order_items: [@order_item]
    )

    create_order

    render json: {}, status: :ok
  end

  def create_draft_order
    validate_cart_items

    return if @cart_items.blank?

    build_order_items
    build_order
    create_order
    update_cart_items

    render json: {}, status: :ok
  end

  def validate_cart_items
    @cart_items = params[:cart_items] ? params[:cart_items].values.map(&:symbolize_keys) : []

    if @cart_items.blank?
      render json: { errors: ['Cart items required'] }, status: :bad_request
      return
    end
  end

  def build_order_items
    @order_items = @cart_items.map do |item|
      cart_item = CartItem.find(item[:id])
      product = cart_item.product
      variant = cart_item.variant

      OrderItem.new(
        product_id: cart_item.product_id,
        quantity: cart_item.quantity,
        original_price: cart_item.original_price,
        price: cart_item.price,
        discount_percentage: product.discount_percentage,
        variant_id: cart_item.variant_id,
        variants: {}
      )
    end
  end

  def build_order
    @order = Order.new(
      customer_uuid: customer_uuid,
      status: 'draft',
      order_items: @order_items
    )
  end

  def create_order
    Order.draft.where(customer_uuid: customer_uuid).destroy_all

    @order.save!
  end

  def update_cart_items
    CartItem.where(id: @cart_items.map{|item| item[:id]}).update_all(order_id: @order.id)
  end

  def put_to_session
    session[:draft_order] = @order.as_json.merge(
      order_items: @order_items.as_json
    )
  end

  def update_params
    params.permit(
      :customer_name,
      :customer_email,
      :customer_phone,
      :shipping_method,
      :payment_method,
      :invoice_required,
      shipping_address: [:address, :province, :district, :ward],
      invoice_data: [:company_name, :tax_number, :address, :note]
    )
  end
end
