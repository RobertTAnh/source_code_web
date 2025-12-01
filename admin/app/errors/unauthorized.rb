class Unauthorized < StandardError
  def initialize(message = "Unauthorized access")
    super
  end
end
