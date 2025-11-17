module ProductCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, product:)
      @context = context
      @product = product
    end

    def call
      validate
      destroy_product unless failure?
      output
    end

    private

    attr_reader :context, :product

    def validate
    end

    def destroy_product
      product.discard!
    end

    def output
      product
    end
  end
end

