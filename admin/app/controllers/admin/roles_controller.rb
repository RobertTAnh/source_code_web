module Admin
  class RolesController < ApplicationController
    before_action :get_role, only: %i[edit update destroy]

    def index
      raise Unauthorized unless can?(:read, :role)

      @records = RoleCmds::GetList.call(context: context, params: params).result
    end

    def new
      @record = Role.new
    end

    def create
      raise Unauthorized unless can?(:create, :role)

      cmd = RoleCmds::Create.call(context: context, params: create_params)

      if cmd.success?
        redirect_to edit_role_url(cmd.result)
      else
        @record = cmd.result
        @errors = cmd.errors
        render 'new'
      end
    end

    def edit
      raise Unauthorized unless can?(:update, @record)
    end

    def update
      raise Unauthorized unless can?(:update, @record)

      cmd = RoleCmds::Update.call(context: context, role: @record, params: edit_params)

      if cmd.success?
        redirect_to edit_role_url(cmd.result, group: current_edit_tab_name)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit
      end
    end

    def destroy
      raise Unauthorized unless can?(:delete, @record) && !@record.protected

      cmd = RoleCmds::Destroy.call(context: context, role: @record)
      redirect_to roles_url, status: 303
    end

    def grant_users_to_role
      raise Unauthorized unless can?(:grant, :role)

      cmd = RoleCmds::GrantUserToRole.call(context: context, params: user_role_params)

      respond_to do |format|
        if cmd.success?
          @new_records = cmd.result
          users = @new_records.map do |user_role|
            user = user_role.user
            {
              name: user.name,
              email: user.email,
              user_role_id: user_role.id
            }
          end
          format.json { render json: users.as_json, status: 200 }
        else
          @errors = cmd.errors
          format.json { render json: @errors, status: 400 }
        end
      end
    end

    def destroy_user_role
      raise Unauthorized unless can?(:grant, :role)

      user_role = UserRole.find(params[:id])
      raise Unauthorized unless can?(:grant, user_role.role)

      cmd = RoleCmds::DestroyUserRole.call(context: context, user_role: user_role)

      respond_to do |format|
        if cmd.success?
          result = cmd.result
          format.json { render json: result.as_json, status: 200 }
        else
          @errors = cmd.errors
          format.json { render json: @errors, status: 400 }
        end
      end
    end

    private

    def get_role
      @record = Role.find(params[:id])
    end

    def create_params
      params.require(:role).permit(:name)
    end

    def edit_params
      strong_params = params.require(:role).permit(:name, :description,
        granted_permissions_attributes: [:id, :permission_id, :granted_to_id, :granted_to_type, :_destroy, :conditions])

      strong_params
    end

    def user_role_params
      params.require(:user_role).permit(:role_id, user_id: [])
    end
  end
end
