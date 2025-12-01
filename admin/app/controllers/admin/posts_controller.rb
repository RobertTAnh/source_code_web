module Admin
  class PostsController < ApplicationController
    include ::MediaCmds::Utils
    before_action :get_post, only: %i[edit update destroy albums]
    loggable_actions :create, :update, :destroy

    if Settings.localized?
      before_action :redirect_to_locale_record, only: %i[edit]
    end

    def index
      raise Unauthorized unless can?(:read, :post)

      @records = PostCmds::Index.call(context: context, params: params).result
      respond_to do |format|
        format.html
        format.csv do
          category_id = params[:filter_category]
          attributes = [:name, :slug, :created_at, :status]
          data_csv = CSV.generate do |csv|
            csv << attributes + [:category]
            @records.limit(nil).each do |record|
              data_attributes = attributes.map{ |attr|  record.public_send(attr) }
              category_name = record&.primary_category&.name
              data_attributes = data_attributes << category_name
              csv << data_attributes 
            end
            csv
          end 
          send_data data_csv, filename: "posts_#{Time.zone.now.strftime("%d-%m-%y")}.csv"
        end
      end
    end

    def edit
      raise Unauthorized unless can?(:read, @record)
    end

    def new
      raise Unauthorized unless can?(:create, :post)

      @record = Post.new
    end

    def create
      raise Unauthorized unless can?(:create, :post)

      cmd = PostCmds::Create.call(context: context, params: create_params)

      @record = cmd.result
      if cmd.success?
        redirect_to edit_post_url(cmd.result)
      else
        @errors = cmd.errors
        render 'new', status: 422
      end
    end

    def update
      raise Unauthorized unless can?(:update, :post)

      cmd = PostCmds::Update.call(context: context, post: @record, params: update_params, extra_params: extra_params)

      if cmd.success?
        redirect_to edit_post_url(cmd.result, group: current_edit_tab_name)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    def destroy
      raise Unauthorized unless can?(:delete, :post)

      cmd = PostCmds::Destroy.call(context: context, post: @record)
      redirect_to posts_url
    end

    def albums
    end

    private

    def create_params
      params.require(:post).permit(:name, :slug, :image, :status, :release_date, tags: [])
    end

    def update_params
      strong_params = params.require(:post).permit(:name, :slug, :image, :description, :status, :display_order,
                                   :release_date, :published_at, content_attributes: CONTENT_PARAMS,
                                   tags: []
                                  )
      if Post.try(:extra_fields_by_config).present?
        strong_params.merge!(extra_fields_attributes: extra_field_params)
      end

      strong_params
    end

    def extra_field_params
      params.require(:post).require(:extra_fields_attributes).permit!
    end

    def extra_params
      params.permit(:primary_category, :custom_html, :delete_custom_html, categories: [])
    end

    def get_post
      @record = Post.find(params[:id])
    end
  end
end
