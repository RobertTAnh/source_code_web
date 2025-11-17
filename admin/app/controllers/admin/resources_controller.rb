module Admin
  class ResourcesController < ApplicationController
    include ::MediaCmds::Utils
    include Admin::DynamicResourceHelper

    before_action :detect_resource
    before_action :get_resource, only: %i[edit update destroy]

    if Settings.localized?
      before_action :redirect_to_locale_record, only: %i[edit]
    end

    loggable_actions :create, :update, :destroy

    def index
      @records = ResourceCmds::GetList.call(context: context, params: params, resource: @resource_model).result
    end

    def edit
    end

    def new
      @record = @resource_model.new
    end

    def create
      cmd = ResourceCmds::Create.call(context: context, params: create_params, resource: @resource_model)

      @record = cmd.result
      if cmd.success?
        redirect_to edit_resource_url(@resource_name, cmd.result)
      else
        @errors = cmd.errors
        render 'new', status: 422
      end
    end

    def update
      cmd = ResourceCmds::Update.call(context: context, resource: @record, params: update_params, extra_params: extra_params)

      if cmd.success?
        redirect_to edit_resource_url(@resource_name, cmd.result, group: current_edit_tab_name)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    def destroy
      cmd = ResourceCmds::Destroy.call(context: context, resource: @record)
      redirect_to resources_url(@resource_name)
    end

    private

    def create_params
      params.require(@resource_name.to_sym).permit(:name, :slug, :image, tags: [])
    end

    def update_params
      strong_params = params.require(@resource_name.to_sym).permit(:name, :slug, :image, :status, :description, properties: {},
                                   content_attributes: CONTENT_PARAMS,
                                   tags: []
                                  )

      if @resource_model.try(:extra_fields_by_config).present?
        strong_params.merge!(extra_fields_attributes: extra_field_params)
      end

      strong_params
    end

    def extra_field_params
      params.require(@resource_name.to_sym).require(:extra_fields_attributes).permit!
    end

    def extra_params
      params.permit(:custom_html, :delete_custom_html, :primary_category, categories: [])
    end

    def get_resource
      @record = @resource_model.find(params[:id])
    end

    def detect_resource
      @resource_name = controller_name.singularize
      @resource_model = @resource_name.capitalize.constantize
    end
  end
end
