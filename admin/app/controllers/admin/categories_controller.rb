module Admin
  class CategoriesController < ApplicationController
    include ::MediaCmds::Utils
    before_action :get_category, only: %i[edit update destroy albums]
    loggable_actions :create, :update, :destroy

    if Settings.localized?
      before_action :redirect_to_locale_record, only: %i[edit]
    end

    def index
      raise Unauthorized unless can?(:read, :category)

      @records = CategoryCmds::GetList.call(context: context, params: params).result
    end

    def new
      raise Unauthorized unless can?(:create, :category)

      @record = Category.new
      @record.content = Content.new
    end

    def create
      raise Unauthorized unless can?(:create, :category)

      cmd = CategoryCmds::Create.call(context: context, params: create_params)

      @record = cmd.result
      if cmd.success?
        redirect_to edit_category_url(cmd.result)
      else
        @errors = cmd.errors
        render 'new', status: 422
      end
    end

    def edit
      raise Unauthorized unless can?(:read, :category)
    end

    def update
      raise Unauthorized unless can?(:update, @record)

      cmd = CategoryCmds::Update.call(context: context, category: @record, params: edit_params)

      if cmd.success?
        redirect_to edit_category_url(cmd.result, group: current_edit_tab_name)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    def destroy
      raise Unauthorized unless can?(:delete, @record)

      cmd = CategoryCmds::Destroy.call(context: context, category: @record)
      redirect_to categories_path(kind: @record.kind)
    end

    def albums
    end

    private

    def get_category
      @record = Category.find(params[:id])
    end

    def create_params
      params.require(:category).permit(:name, :slug, :parent_id, :kind, tags: [])
    end

    def edit_params
      strong_params = params.require(:category).permit(:name, :slug, :description, :parent_id, :kind, :image, :status, :display_order, :published_at,
                                   content_attributes: CONTENT_PARAMS,
                                    tags: [])

      if Category.try(:extra_fields_by_config).present?
        strong_params.merge!(extra_fields_attributes: extra_field_params)
      end

      strong_params
    end

    def extra_field_params
      params.require(:category).require(:extra_fields_attributes).permit!
    end
  end
end
