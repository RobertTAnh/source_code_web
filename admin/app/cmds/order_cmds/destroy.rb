module OrderCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, order:)
      @context = context
      @order = order
    end

    def call
      validate
      destroy_order unless failure?
      output
    end

    private

    attr_reader :context, :order

    def validate
    end

    def destroy_order
      order.discard!
    end

    def output
      order
    end
  end
end


