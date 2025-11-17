class DevController < ActionController::Base
  # Redirect uploads to legacy production host
  def uploads
    redirect_to "#{ENV['LEGACY_ASSETS_HOST']}/uploads/#{params[:path]}.#{params[:format]}", allow_other_host: true
  end
end
