module Admin
  class PageContentsController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :find_owner, only: %i[new create]
    before_action :get_data, only: %i[new]

    def create
      PageContent.update_for(@owner, params[:owner_data]) if params[:owner_data]
      PageContent.update_for(Theme.current, params[:theme_data]) if params[:theme_data]

      render json: { result: 'success' }
    end

    private

    def find_owner
      @owner = params.fetch(:owner_type).constantize.find(params.fetch(:owner_id))
    end

    def get_data
      @owner_data = PageContent.for_owner(@owner)&.data || {}
      @theme_data = PageContent.for_owner(Theme.current)&.data || {}
    end
  end
end
