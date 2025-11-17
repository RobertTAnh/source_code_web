class Order < ApplicationRecord
  include SoftDelete
  include HasCode

  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :nullify

  enum :status, { draft: 'draft', created: 'created' }

  def has_vat_fee?
    vat_fee && vat_fee > 0
  end

  def vat_fee_amount
    vat_fee ? sub_total * vat_fee : 0
  end

  def sub_total
    order_items.sum(&:total_price)
  end

  def total_after_vat
    sub_total + vat_fee_amount
  end

  def total_price
    total_after_vat
  end
end
