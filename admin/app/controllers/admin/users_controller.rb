module Admin
  class UsersController < ApplicationController
    include ::MediaCmds::Utils
    before_action :get_user, only: %i[edit update destroy]

    def index
      raise Unauthorized unless can?(:read, :user)

      @records = UserCmds::GetList.call(context: context, params: params).result
    end

    def new
      raise Unauthorized unless can?(:create, :user)

      @record = User.new
    end

    def create
      raise Unauthorized unless can?(:create, :user)

      cmd = UserCmds::Create.call(context: context, params: create_params)

      if cmd.success?
        redirect_to edit_user_url(cmd.result)
      else
        @record = cmd.result
        @errors = cmd.errors
        render 'new'
      end
    end

    def edit
      raise Unauthorized unless can?(:read, @record)
    end

    def update
      raise Unauthorized unless can?(:update, @record)

      cmd = UserCmds::Update.call(context: context, user: @record, params: edit_params, extra_params: extra_params)

      if cmd.success?
        redirect_to edit_user_url(cmd.result)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit
      end
    end

    def destroy
      raise Unauthorized unless can?(:delete, @record)

      cmd = UserCmds::Destroy.call(context: context, user: @record)
      redirect_to users_url
    end

    private

    def get_user
      @record = User.find(params[:id])
    end

    def create_params
      params.require(:user).permit(:name, :slug, :email, :password)
    end

    def edit_params
      params.require(:user).permit(:name, :image,
                                   content_attributes: [:id, :body, :meta_title, :meta_keywords,
                                                        :meta_description, :tracking_head,
                                                        :tracking_body, :tracking_content, :description, :seo_index],
                                   extra_fields_attributes: [:id, :value])
    end

    def extra_params
      params.permit(:primary_category, categories: [])
    end
  end
end
