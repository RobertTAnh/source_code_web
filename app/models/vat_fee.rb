class VatFee
  DEFAULT_VAT_FEE = 0.1

  class << self
    def get
      (WebConfig.for('orders.vat_fee') || DEFAULT_VAT_FEE).to_f
    end
  end
end
