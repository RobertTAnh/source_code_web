class Cart
  attr_accessor :items

  def initialize(cart_items)
    @items = cart_items
  end

  delegate :any?, :empty?, :count, to: :items

  def sub_total
    items.sum(&:total_price)
  end

  def has_product?(product)
    !!items.detect {|item| item.product_id == (product.try(:id) || product) }
  end

  class << self
    def get(customer_uuid)
      Cart.new(
        CartItem.where(customer_uuid: customer_uuid).includes(:product).to_a
      )
    end
  end
end
