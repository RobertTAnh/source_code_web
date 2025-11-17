class Sku < String
  DEFAULT_PREFIX = 'S'.freeze

  attr_reader :prefix

  def initialize(prefix: nil)
    @prefix = prefix || DEFAULT_PREFIX

    super(generate)
  end

  def generate
    [prefix, SecureRandom.hex(6).upcase].join
  end
end
