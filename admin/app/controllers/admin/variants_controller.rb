module Admin
  class VariantsController < ApplicationController
    before_action :get_variant, only: [:destroy, :update]

    def destroy
      cmd = VariantCmds::Destroy.call(context: context, variant: @variant)
      respond_to do |format|
        if cmd.success?
          format.json { render json: @variant, status: 200 }
        else
          @errors = cmd.errors
          format.json { render json: @errors, status: 400 }
        end
      end
    end

    def update
      cmd = VariantCmds::Update.call(context: context, variant: @variant, params: update_params)

      respond_to do |format|
        if cmd.success?
          format.json { render json: @variant, status: 200 }
        else
          @errors = cmd.errors
          format.json { render json: @errors, status: 400 }
        end
      end
    end

    private
    def get_variant
      @variant = Variant.find(params[:id])
    end

    def update_params
      params.require(:variant).permit(:image, :price, :original_price, :status, properties: {})
    end
  end
end
