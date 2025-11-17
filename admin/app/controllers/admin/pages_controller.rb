module Admin
  class PagesController < ApplicationController
    include ::MediaCmds::Utils
    before_action :get_page, only: %i[edit update destroy albums]
    loggable_actions :create, :update, :destroy

    if Settings.localized?
      before_action :redirect_to_locale_record, only: %i[edit]
    end

    def index
      @records = PageCmds::Index.call(context: context, params: params).result
    end

    def edit
    end

    def new
      @record = Page.new
    end

    def create
      cmd = PageCmds::Create.call(context: context, params: create_params)

      @record = cmd.result
      if cmd.success?
        redirect_to edit_page_url(cmd.result)
      else
        @errors = cmd.errors
        render 'new', status: 422
      end
    end

    def update
      cmd = PageCmds::Update.call(context: context, page: @record, params: update_params, extra_params: extra_params)

      if cmd.success?
        redirect_to edit_page_url(cmd.result, group: current_edit_tab_name)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    def destroy
      cmd = PageCmds::Destroy.call(context: context, page: @record)
      redirect_to pages_url
    end

    private

    def create_params
      params.require(:page).permit(:name, :slug, :image, tags: [])
    end

    def update_params
      strong_params = params.require(:page).permit(:name, :slug, :image, :status, :description,
                                   content_attributes: CONTENT_PARAMS,
                                   tags: []
                                  )

      if Page.try(:extra_fields_by_config).present?
        strong_params.merge!(extra_fields_attributes: extra_field_params)
      end

      strong_params
    end

    def extra_field_params
      params.require(:page).require(:extra_fields_attributes).permit!
    end

    def extra_params
      params.permit(:custom_html, :delete_custom_html)
    end

    def get_page
      @record = Page.find(params[:id])
    end
  end
end
