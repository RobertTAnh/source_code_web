module PageOps
  class Cart < BaseOperation
    def call
      get_cart

      prepare_data

      render_view
    end

    private

    attr_reader :cart

    def get_cart
      @cart = ::Cart.get(context.customer_uuid)
    end

    def prepare_data
      context.instance_variable_set '@cart', cart
    end

    def render_view
      context.render_for cart
    end
  end
end
