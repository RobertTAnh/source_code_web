module HasStatus
  extend ActiveSupport::Concern

  included do
    enum status: { published: 'published', unpublished: 'unpublished', unlisted: 'unlisted' }
    before_create :set_default_status, unless: :status?
  end

  private
  def set_default_status
    self.status = 'unpublished'
  end
end
