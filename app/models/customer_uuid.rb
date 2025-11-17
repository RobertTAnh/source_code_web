class CustomerUuid < String
  def initialize
    super(generate)
  end

  def generate
    SecureRandom.uuid
  end
end
