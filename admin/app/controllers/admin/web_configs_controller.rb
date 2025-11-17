module Admin
  class WebConfigsController < ApplicationController
    before_action :set_record, only: [:edit, :update, :update_advanced_settings, :advanced_settings]
    loggable_actions :update_advanced_settings, :update

    def edit
      @configs = WebConfig.for("website.settings")
    end

    def advanced_settings
      @configs = WebConfig.for("website.advanced_settings")
    end

    def update_advanced_settings
      cmd = WebConfigCmds::Update.call(context: context, web_config: @record, params: web_config_params, extra_params: nil)

      if cmd.success?
        redirect_to advanced_settings_url
      else
        @record = cmd.result
        @errors = cmd.errors

        render :advanced_settings, status: 422
      end
    end

    def update
      cmd = WebConfigCmds::Update.call(context: context, web_config: @record, params: web_config_params, extra_params: nil)

      if cmd.success?
        redirect_to web_configs_url
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    private

    def web_config_params
      params.require(:web_config).permit.merge(extra_fields_attributes: extra_field_params)
    end

    def extra_field_params
      params.require(:web_config).require(:extra_fields_attributes).permit!
    end

    def set_record
      @record = WebConfig.current
    end
  end
end

