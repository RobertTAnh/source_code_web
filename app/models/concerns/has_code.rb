module HasCode
  extend ActiveSupport::Concern

  included do
    validates :code, presence: true

    before_validation :generate_code, on: :create
  end

  def generate_code
    5.times.each do
      self.code = UniqueCode.new

      break unless self.class.where(code: self.code).exists?
    end
  end
end
