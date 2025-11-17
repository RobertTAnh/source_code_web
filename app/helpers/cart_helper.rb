module CartHelper
  def cart
    @cart ||= Cart.get(customer_uuid)
  end

  def cart_count
    @cart_count ||= CartItem.where(customer_uuid: customer_uuid).count
  end
end
