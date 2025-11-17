module OrderCmds
  class Update
    prepend BaseCmd

    def initialize(context:, order:, params:, extra_params:)
      @context = context
      @order = order
      @params = params
      @extra_params = extra_params
    end

    def call
      validate
      update unless failure?
      output
    end

    private

    attr_reader :context, :params, :order, :extra_params

    def validate
      order.assign_attributes(params)

      return if order.valid?

      add_model_errors order
    end

    def update
      order.save!
    end

    def output
      order
    end
  end
end

