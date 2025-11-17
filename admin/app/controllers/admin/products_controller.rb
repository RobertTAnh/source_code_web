module Admin
  class ProductsController < ApplicationController
    include ::MediaCmds::Utils
    before_action :get_product, only: %i[edit update destroy albums]
    loggable_actions :create, :update, :destroy

    if Settings.localized?
      before_action :redirect_to_locale_record, only: %i[edit]
    end

    def index
      @records = ProductCmds::GetList.call(context: context, params: params).result
    end

    def new
      @record = Product.new
      @record.content = Content.new
    end

    def create
      cmd = ProductCmds::Create.call(context: context, params: create_params)

      @record = cmd.result
      if cmd.success?
        redirect_to edit_product_url(cmd.result)
      else
        @errors = cmd.errors
        render 'new', status: 422
      end
    end

    def edit
    end

    def update
      cmd = ProductCmds::Update.call(context: context, product: @record, params: edit_params, extra_params: extra_params)

      if cmd.success?
        redirect_to edit_product_url(cmd.result, group: current_edit_tab_name)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    def destroy
      cmd = ProductCmds::Destroy.call(context: context, product: @record)
      redirect_to products_url, status: 303
    end

    def albums
    end

    private

    def get_product
      @record = Product.find(params[:id])
    end

    def create_params
      params.require(:product).permit(:name, :slug, :kind, tags: [])
    end

    def edit_params
      strong_params = params.require(:product).permit(:name, :slug, :image, :description, :status, :original_price,
                                   :price, :sku, :display_order, properties: {},
                                   content_attributes: CONTENT_PARAMS,
                                   tags: [], variant_options: [:name, values: []])

      if Product.try(:extra_fields_by_config).present?
        strong_params.merge!(extra_fields_attributes: extra_field_params)
      end

      strong_params
    end

    def extra_field_params
      params.require(:product).require(:extra_fields_attributes).permit!
    end

    def extra_params
      params.permit(:primary_category, :custom_html, :delete_custom_html, categories: [])
    end
  end
end
