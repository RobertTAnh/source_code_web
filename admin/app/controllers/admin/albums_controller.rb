module Admin
  class AlbumsController < ApplicationController
    include ::MediaCmds::Utils
    before_action :get_album, only: %i[edit update destroy]
    loggable_actions :create, :update, :destroy

    def index
      raise Unauthorized unless can?(:read, :album)

      @records = AlbumCmds::Index.call(context: context, params: params).result
    end

    def edit
      raise Unauthorized unless can?(:read, @record)
    end

    def new
      raise Unauthorized unless can?(:create, :album)

      @record = Album.new
    end

    def create
      raise Unauthorized unless can?(:create, :album)

      cmd = AlbumCmds::Create.call(context: context, params: create_params)

      @record = cmd.result
      if cmd.success?
        redirect_to edit_album_url(cmd.result)
      else
        @errors = cmd.errors
        render 'new', status: 422
      end
    end

    def update
      raise Unauthorized unless can?(:update, @record)

      cmd = AlbumCmds::Update.call(context: context, album: @record, params: update_params)

      if cmd.success?
        redirect_to edit_album_url(cmd.result, group: current_edit_tab_name)
      else
        @record = cmd.result
        @errors = cmd.errors

        render :edit, status: 422
      end
    end

    def destroy
      raise Unauthorized unless can?(:delete, @record)

      cmd = AlbumCmds::Destroy.call(context: context, album: @record)
      redirect_to albums_url
    end

    private

    def create_params
      params.require(:album).permit(:name, :slug, :owner_type, :owner_id)
    end

    def update_params
      params.require(:album).permit(:name, :slug)
    end

    def get_album
      @record = Album.find(params[:id])
    end
  end
end
