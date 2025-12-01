module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Unauthorized do |exception|
      log_trace exception
      render_error(403)
    end
  end

  private

  def render_error status
    return render file: "#{Rails.root}/public/admin/#{status}.html", layout: false, status: status
  end

  def log_trace exception
    Rails.logger.error((["#{self.class} - #{exception.class}: #{exception.message}"] + exception.backtrace).join("\n"))
  end
end

