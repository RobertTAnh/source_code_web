class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :variant, optional: true

  def price
    variant ? variant.price : product.price
  end

  def original_price
    variant ? variant.original_price : product.original_price
  end

  def total_price
    quantity * (price || 0)
  end
end
