module Admin
  class OrdersController < ApplicationController
    include ::MediaCmds::Utils
    before_action :get_order, only: %i[show edit update destroy]
    loggable_actions :create, :update, :destroy

    def index
      @records = OrderCmds::GetList.call(context: context, params: params).result
    end

    def edit
    end

    def show
    end

    def update
      cmd = OrderCmds::Update.call(context: context, order: @record, params: edit_params, extra_params: extra_params)

      if cmd.success?
        redirect_to order_url(cmd.result)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    def destroy
      cmd = OrderCmds::Destroy.call(context: context, order: @record)
      redirect_to orders_url
    end

    private

    def get_order
      @record = Order.find(params[:id])
    end

    def edit_params
      params.require(:order).permit(:customer_name, :customer_email, :customer_phone, :payment_method, :shipping_method, :invoice_required, :status, :vat_fee,
                                    shipping_address: [:address, :province, :district, :ward],
                                    invoice_data: [:company_name, :tax_number, :address, :note])
    end

    def extra_params
      params.permit(:primary_category, categories: [])
    end
  end
end
