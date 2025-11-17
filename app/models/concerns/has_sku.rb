module HasSku
  extend ActiveSupport::Concern

  included do
    validates :sku, presence: true

    before_validation :generate_sku, on: :create
  end

  def generate_sku
    5.times.each do
      self.sku = Sku.new

      break unless self.class.where(sku: self.sku).exists?
    end
  end
end
