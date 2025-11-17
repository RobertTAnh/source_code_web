module Admin
  class GlobalSlugsController < ApplicationController
    include ApplicationHelper
    def create
      cmd = GlobalSlugCmds::Create.call(context: context, params: create_params)

      respond_to do |format|
        if cmd.success?
          @record = cmd.result
          serialize = @record.as_json
          serialize[:created_at] = format_date @record.created_at
          format.json { render json: serialize, status: :created }
        else
          @errors = cmd.errors
          format.json { render json: @errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      cmd = GlobalSlugCmds::Destroy.call(context: context, params: params)
      respond_to do |format|
        if cmd.success?
          @record = cmd.result
          format.json { render json: @record, status: 200 }
        else
          @errors = cmd.errors
          format.json { render json: @errors, status: 400 }
        end
      end
    end

    private

    def create_params
      params.require(:global_slug).permit(:name, :sluggable_type, :sluggable_id, :primary)
    end
  end
end

