module VariantCmds
  class Destroy
    prepend BaseCmd

    def initialize(context:, variant:)
      @context = context
      @variant = variant
    end

    def call
      step :destroy
      step :output
    end

    private

    attr_reader :context, :variant

    def destroy
      variant.destroy!
    end

    def output
      variant
    end
  end
end
