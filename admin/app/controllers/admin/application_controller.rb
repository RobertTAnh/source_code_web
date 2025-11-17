module Admin
  class ApplicationController < ActionController::Base
    helper ::ConfigHelper
    helper WebRouteHelper
    include Admin::Localizable if Settings.localized?
    before_action :authenticate_user!
    include Loggable

    def context
    end

    def current_edit_tab_name
      CGI.parse(URI(request.referer).query || '').dig('group', 0)
    end

    CONTENT_PARAMS = [:id, :body, :meta_title, :meta_keywords,
                      :meta_description, :meta_image, :tracking_head,
                      :tracking_body, :tracking_content,
                      :description, :seo_index,
                      :seo_schema_breadcumb, :seo_schema]
  end
end
