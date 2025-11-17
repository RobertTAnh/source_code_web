class BaseOperation
  def initialize(context)
    @context = context
  end

  private

  attr_reader :context
end
