class CartItemsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :find_cart_item, only: %i[update destroy]

  def create
    if cart_item = CartItem.where(customer_uuid: customer_uuid, product_id: cart_item_params[:product_id], variant_id: cart_item_params[:variant_id].presence ).first
      cart_item.quantity += cart_item_params[:quantity].to_i
    else
      cart_item = CartItem.new(cart_item_params)
    end

    if cart_item.save
      render json: { result: 'success' }, status: :created
    else
      render json: { errors: cart_item.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @cart_item.update(update_params)
      render json: json_cart_item, status: :ok
    else
      render json: { errors: @cart_item.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @cart_item.destroy

    render json: json_cart_item, status: :ok
  end

  private

  def cart_item_params
    params.permit(:product_id, :product_sku, :quantity, :variant_id).merge(
      customer_uuid: customer_uuid
    )
  end

  def update_params
    params.permit(:quantity)
  end

  def find_cart_item
    @cart_item = CartItem.find_by(id: params[:id]) 

    return if @cart_item

    render json: { errors: ['Cart item not found'] }, status: :not_found
  end

  def json_cart_item
    @cart_item.as_json.merge({
      price: @cart_item.price,
      total_price: @cart_item.total_price
    })
  end
end
