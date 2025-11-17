class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :variant, optional: true

  def total_price
    quantity * (price || 0)
  end
end
